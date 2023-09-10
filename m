Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5032BEE49A4
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 20:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjIJUoc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 16:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjIJUob (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 16:44:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15CA188
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 13:44:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CB2C433CA;
        Sun, 10 Sep 2023 20:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694378667;
        bh=dDkdJWGGiy//RR7AWWVhpLf78066+abk18LBiZ3RRqk=;
        h=Date:To:From:Subject:From;
        b=YBNg0geiUrQ553YBXFVOfQ8ODAgKaShN4ztmgp8h0GX6cKKuqPMhu/MGlxicV7ai1
         4fvxUst31h0RAe3GfDa2pZJYx1j10md4vkaSZG2Ej7LrfIYaYx1TwRrJ7j7Xo9HzLw
         Nv7q0kmj4dw4EZn34F8k5vsHc/UXC9ROAadRZYsA=
Date:   Sun, 10 Sep 2023 13:44:26 -0700
To:     mm-commits@vger.kernel.org, wsa+renesas@sang-engineering.com,
        loic.poulain@linaro.org, justin.he@arm.com, brauner@kernel.org,
        axboe@kernel.dk, jianyong.wu@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + init-mount-print-pretty-name-of-root-device-when-panics.patch added to mm-nonmm-unstable branch
Message-Id: <20230910204427.30CB2C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/mount: print pretty name of root device when panicing
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-mount-print-pretty-name-of-root-device-when-panics.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-mount-print-pretty-name-of-root-device-when-panics.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jianyong Wu <jianyong.wu@arm.com>
Subject: init/mount: print pretty name of root device when panicing
Date: Thu, 7 Sep 2023 09:10:25 +0000

Given a wrong root device, current log may not give the pretty name
which is useful to locate root cause.

For example, there are 2 blk devs in a VM, /dev/vda which has 2 partitials
/dev/vda1 and /dev/vda2 and /dev/vdb which is blank.  /dev/vda2 is the
right root dev.  When set "root=/dev/vdb", we get error log:

[    0.635575] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(254,16)

It's not straightforward to find out the root cause as there is lack of
the root devive name therefore hard for people to get those info from the
device number, in the example, (254,16).

It is more comprehensive way to hint the root cause if pretty name is
given here, like:

[    0.559887] Kernel panic - not syncing: VFS: Unable to mount root fs on "/dev/vdb" or unknown-block(254,16)

Link: https://lkml.kernel.org/r/20230907091025.3436878-1-jianyong.wu@arm.com
Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Justin He <justin.he@arm.com>
Cc: Loic Poulain <loic.poulain@linaro.org>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/do_mounts.c~init-mount-print-pretty-name-of-root-device-when-panics
+++ a/init/do_mounts.c
@@ -244,7 +244,7 @@ retry:
 	for (i = 0, p = fs_names; i < num_fs; i++, p += strlen(p)+1)
 		printk(" %s", p);
 	printk("\n");
-	panic("VFS: Unable to mount root fs on %s", b);
+	panic("VFS: Unable to mount root fs on \"%s\" or %s", pretty_name, b);
 out:
 	put_page(page);
 }
_

Patches currently in -mm which might be from jianyong.wu@arm.com are

init-mount-print-pretty-name-of-root-device-when-panics.patch

