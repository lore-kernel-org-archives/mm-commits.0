Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC19C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjASBOO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjASBNr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:13:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE078689E9
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:13:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B57361B0E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1965C433F0;
        Thu, 19 Jan 2023 01:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090819;
        bh=lcIPwIrmQ18SKQ7G2jFV3huKTox7zgo6MISaB5JX27c=;
        h=Date:To:From:Subject:From;
        b=fkwoV1Pr37ydrKAXfpKM5DRDzWxLA19A+EpnHRN9HiNxi/bIcP/+Aw5wc5Xk+zPd9
         qdxC8yETJV0UNOo+nd7lcrDX3fnSBvAtXmflwB+UZaIgrgFb1zy4YYmsskHWWNk4y8
         HTbH2GWPavd4nQHw8FjP6vGo2ntfpag7A62XTwiA=
Date:   Wed, 18 Jan 2023 17:13:38 -0800
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        lkp@intel.com, keescook@chromium.org, jorgelo@chromium.org,
        jannh@google.com, hughd@google.com, dverkamp@chromium.org,
        dmitry.torokhov@gmail.com, dh.herrmann@gmail.com,
        jeffxu@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd-add-write-seals-when-apply-seal_exec-to-executable-memfd.patch removed from -mm tree
Message-Id: <20230119011338.E1965C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memfd: add write seals when apply SEAL_EXEC to executable memfd
has been removed from the -mm tree.  Its filename was
     mm-memfd-add-write-seals-when-apply-seal_exec-to-executable-memfd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Xu <jeffxu@google.com>
Subject: mm/memfd: add write seals when apply SEAL_EXEC to executable memfd
Date: Thu, 15 Dec 2022 00:12:04 +0000

In order to avoid WX mappings, add F_SEAL_WRITE when apply F_SEAL_EXEC to
an executable memfd, so W^X from start.

This implys application need to fill the content of the memfd first, after
F_SEAL_EXEC is applied, application can no longer modify the content of
the memfd.

Typically, application seals the memfd right after writing to it.
For example:
1. memfd_create(MFD_EXEC).
2. write() code to the memfd.
3. fcntl(F_ADD_SEALS, F_SEAL_EXEC) to convert the memfd to W^X.
4. call exec() on the memfd.

Link: https://lkml.kernel.org/r/20221215001205.51969-5-jeffxu@google.com
Signed-off-by: Jeff Xu <jeffxu@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: kernel test robot <lkp@intel.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memfd.c~mm-memfd-add-write-seals-when-apply-seal_exec-to-executable-memfd
+++ a/mm/memfd.c
@@ -222,6 +222,12 @@ static int memfd_add_seals(struct file *
 		}
 	}
 
+	/*
+	 * SEAL_EXEC implys SEAL_WRITE, making W^X from the start.
+	 */
+	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
+		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
+
 	*file_seals |= seals;
 	error = 0;
 
_

Patches currently in -mm which might be from jeffxu@google.com are


