Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BB6C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A96D9610F7
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbhKKCmI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233120AbhKKCmH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:42:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9746061260;
        Thu, 11 Nov 2021 02:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598358;
        bh=s+zVtIt/IJUC6wQ9KvzZS7msR9TFp4UJFtK282osqzo=;
        h=Date:From:To:Subject:From;
        b=F1lZZseA9SVwQVF4a47hhBvcn62iZtVLh2BgOPz7iFwN+4F6iNrCzKa34QAxvoXTH
         wmCUOHXlTQBgbi69vBWnkH/Ku2WSWAW79XNdboVL5emfSVnGwwnmSOLhY0f1hERyt/
         R1mbdTXSrYZfTQPedKgQhhQ27yOPAe/F/oTSxigQ=
Date:   Wed, 10 Nov 2021 18:39:18 -0800
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org,
        sven@narfation.org
Subject:  [merged]
 scripts-spellingtxt-fix-mistake-version-of-synchronization.patch removed
 from -mm tree
Message-ID: <20211111023918.dNLPXXx3L%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: fix "mistake" version of "synchronization"
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-fix-mistake-version-of-synchronization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sven Eckelmann <sven@narfation.org>
Subject: scripts/spelling.txt: fix "mistake" version of "synchronization"

If both "mistake" version and "correction" version are the same, a warning
message is created by checkpatch which is impossible to fix.  But it was
noticed that Colan Ian King created a commit e6c0a0889b80 ("ALSA: aloop:
Fix spelling mistake "synchronization" -> "synchronization"") which
suggests that this spelling mistake was fixed by replacing the word
"synchronization" with itself.  But the actual diff shows that the mistake
in the code was "sychronization".  It is rather likely that the "mistake"
in spelling.txt should have been the latter.

Link: https://lkml.kernel.org/r/20210926065529.6880-1-sven@narfation.org
Fixes: 2e74c9433ba8 ("scripts/spelling.txt: add more spellings to spelling.txt")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Reviewed-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/spelling.txt~scripts-spellingtxt-fix-mistake-version-of-synchronization
+++ a/scripts/spelling.txt
@@ -1450,7 +1450,7 @@ syfs||sysfs
 symetric||symmetric
 synax||syntax
 synchonized||synchronized
-synchronization||synchronization
+sychronization||synchronization
 synchronuously||synchronously
 syncronize||synchronize
 syncronized||synchronized
_

Patches currently in -mm which might be from sven@narfation.org are


