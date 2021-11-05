Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD3CC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2B916124F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhKEUha (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230369AbhKEUh1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:37:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 367C061212;
        Fri,  5 Nov 2021 20:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144480;
        bh=YmJN9k+AvaTAJe4caCznDxTBuY6tu4WmKoSVS/t4vgQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=un60l7yN+1dnfo+YkSDfwBnaT1fCOEGvpe5rkC/o9ExTd4HVTlAlYkEZ++ODKmYN7
         nBn3EKSez9jC13TZPefO39vW31qR1jfq5pkMA/ZcNrJUsrifuuab6jjHyuSSqlnM7g
         Eq9u6/tX+aLtsC64lARw/jBB6I8EOFUggaYeC+ZI=
Date:   Fri, 05 Nov 2021 13:34:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sven@narfation.org,
        torvalds@linux-foundation.org
Subject:  [patch 002/262] scripts/spelling.txt: fix "mistake"
 version of "synchronization"
Message-ID: <20211105203439.Tb9TpW8XV%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
