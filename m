Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B02C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiJRB5b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiJRB5b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:57:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3331672B73
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:57:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFE82612B4
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F78C433C1;
        Tue, 18 Oct 2022 01:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666058249;
        bh=MKttmTDDO3lO3W6w6hBQQhfb/66Ff1WnjZrgPJmywOI=;
        h=Date:To:From:Subject:From;
        b=uALvrVRHRqbdnlV0Gez2AZEpXUICjRQtd+u7yNTJYs6BJ1cOrb0NIcLbmQSnviJv7
         IxpDqD7+B2QMcNjnUaPADg7EA4bbbOzjLgyZpHQ7T9GKU0SIPKHPd22C55CAy9BRmF
         lb+BFpH0bqlLq9iqnQ2Yod6r4Ebg7YoIR6fG7XdQ=
Date:   Mon, 17 Oct 2022 18:57:28 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        siddhesh@gotplt.org, oliver.sang@intel.com, miklos@szeredi.hu,
        dhowells@redhat.com, cmaiolino@redhat.com, raven@themaw.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ext4-fix-possible-null-pointer-dereference.patch added to mm-nonmm-unstable branch
Message-Id: <20221018015729.24F78C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: fix possible null pointer dereference
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ext4-fix-possible-null-pointer-dereference.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ext4-fix-possible-null-pointer-dereference.patch

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
From: Ian Kent <raven@themaw.net>
Subject: ext4: fix possible null pointer dereference
Date: Tue, 20 Sep 2022 15:26:23 +0800

Patch series "vfs: fix a mount table handling problem", v3.

Whenever a mount has an empty "source" (aka mnt_fsname), the glibc
function getmntent incorrectly parses its input, resulting in reporting
incorrect data to the caller.

The problem is that the get_mnt_entry() function in glibc's
misc/mntent_r.c assumes that leading whitespace on a line can always be
discarded because it will always be followed by a # for the case of a
comment or a non-whitespace character that's part of the value of the
first field.  However, this assumption is violated when the value of the
first field is an empty string.

This is fixed in the mount API code by simply checking for a pointer that
contains a NULL and treating it as a NULL pointer.


This patch (of 2):

It could be the case that the file system parameter ->string value is NULL
rather than a zero length string.

Guard against this possibility in ext4_parse_param().

Link: https://lkml.kernel.org/r/166365872189.39016.10771273319597352356.stgit@donald.themaw.net
Link: https://lkml.kernel.org/r/166365878336.39016.10934709128005232231.stgit@donald.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Reported-by: kernel test robot <oliver.sang@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Siddhesh Poyarekar <siddhesh@gotplt.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c~ext4-fix-possible-null-pointer-dereference
+++ a/fs/ext4/super.c
@@ -2099,12 +2099,12 @@ static int ext4_parse_param(struct fs_co
 	switch (token) {
 #ifdef CONFIG_QUOTA
 	case Opt_usrjquota:
-		if (!*param->string)
+		if (!param->string || !*param->string)
 			return unnote_qf_name(fc, USRQUOTA);
 		else
 			return note_qf_name(fc, USRQUOTA, param);
 	case Opt_grpjquota:
-		if (!*param->string)
+		if (!param->string || !*param->string)
 			return unnote_qf_name(fc, GRPQUOTA);
 		else
 			return note_qf_name(fc, GRPQUOTA, param);
_

Patches currently in -mm which might be from raven@themaw.net are

ext4-fix-possible-null-pointer-dereference.patch
vfs-parse-deal-with-zero-length-string-value.patch

