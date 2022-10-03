Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83DE2C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiJCVaU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiJCV3v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1F8578AE
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDB3B610D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A42C433C1;
        Mon,  3 Oct 2022 21:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832156;
        bh=kp36Aq7ZLgojUL6zpubaX0nDAaSh9IRwZmSbSVcA/Is=;
        h=Date:To:From:Subject:From;
        b=yuR6yffHkntLz/jXx83qkhB/HH/zN24LynzkxSTKWXWTO90KLDTuMyMS3VmD0bgYM
         lPz+waTlE2JlHPuPuuZh0l4zhHqqeNjdBNRptforaaI8hlRdG9dy6hAxbaU6AoCkaM
         qK4fVYrQZzz8HN4DzW5PXSnDlNv8pbQwLDd/c4vE=
Date:   Mon, 03 Oct 2022 14:22:35 -0700
To:     mm-commits@vger.kernel.org, iago@endocode.com, adobriyan@gmail.com,
        lukas.bulwahn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-make-config-proc_children-depend-on-proc_fs.patch removed from -mm tree
Message-Id: <20221003212236.52A42C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc: make config PROC_CHILDREN depend on PROC_FS
has been removed from the -mm tree.  Its filename was
     proc-make-config-proc_children-depend-on-proc_fs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: proc: make config PROC_CHILDREN depend on PROC_FS
Date: Fri, 9 Sep 2022 14:25:29 +0200

Commit 2e13ba54a268 ("fs, proc: introduce CONFIG_PROC_CHILDREN")
introduces the config PROC_CHILDREN to configure kernels to provide the
/proc/<pid>/task/<tid>/children file.

When one deselects PROC_FS for kernel builds without /proc/, the config
PROC_CHILDREN has no effect anymore, but is still visible in menuconfig.

Add the dependency on PROC_FS to make the PROC_CHILDREN option disappear
for kernel builds without /proc/.

Link: https://lkml.kernel.org/r/20220909122529.1941-1-lukas.bulwahn@gmail.com
Fixes: 2e13ba54a268 ("fs, proc: introduce CONFIG_PROC_CHILDREN")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Cc: Iago López Galeiras <iago@endocode.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/Kconfig~proc-make-config-proc_children-depend-on-proc_fs
+++ a/fs/proc/Kconfig
@@ -92,6 +92,7 @@ config PROC_PAGE_MONITOR
 
 config PROC_CHILDREN
 	bool "Include /proc/<pid>/task/<tid>/children file"
+	depends on PROC_FS
 	default n
 	help
 	  Provides a fast way to retrieve first level children pids of a task. See
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

ia64-update-config-files.patch

