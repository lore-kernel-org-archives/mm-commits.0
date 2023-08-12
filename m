Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0799DC001E0
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjHLWFM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjHLWFL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB1C9F
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDDA7620A3
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD38C433C8;
        Sat, 12 Aug 2023 22:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877913;
        bh=LsijR+j6R2mDJCzUJm8/uvTneCVRaWj3dYK33lIbJUM=;
        h=Date:To:From:Subject:From;
        b=s/5/+bGhMqyCFTM5ueTzPENz/cTwI9JF3vAKs26nCYvfVQ4hItPB53HHtH2CAku8g
         IxrzXq3NwCoxTlBj4UwK6Y24ujGUgxLsg3NsCKvwbHUOWD1IUKAqc5HH2r2ptGfeOU
         vuuKifI7tOxIReYQAKOtz70J44kRmgLXcQ+0xXdY=
Date:   Sat, 12 Aug 2023 15:05:12 -0700
To:     mm-commits@vger.kernel.org, bjorn@kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-skip-proc-empty-vm-on-anything-but-amd64-and-i386.patch removed from -mm tree
Message-Id: <20230812220513.4FD38C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc: skip proc-empty-vm on anything but amd64 and i386
has been removed from the -mm tree.  Its filename was
     proc-skip-proc-empty-vm-on-anything-but-amd64-and-i386.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: skip proc-empty-vm on anything but amd64 and i386
Date: Fri, 30 Jun 2023 21:34:34 +0300

This test is arch specific, requires "munmap everything" primitive.

Link: https://lkml.kernel.org/r/20230630183434.17434-2-adobriyan@gmail.com
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Björn Töpel <bjorn@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~proc-skip-proc-empty-vm-on-anything-but-amd64-and-i386
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -1,3 +1,4 @@
+#if defined __amd64__ || defined __i386__
 /*
  * Copyright (c) 2022 Alexey Dobriyan <adobriyan@gmail.com>
  *
@@ -402,3 +403,9 @@ int main(void)
 
 	return rv;
 }
+#else
+int main(void)
+{
+	return 4;
+}
+#endif
_

Patches currently in -mm which might be from adobriyan@gmail.com are

adfs-delete-unused-union-adfs_dirtail-definition.patch

