Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC2A14F123
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736741715; cv=none; b=n8+Nw2rGmAd13mYThGHbAluN/crKtyp0oQ7MTqxGdy0wGHGcWwOcDlgg3EHVoWVn62FzUvEaj6LCpKBp9F17ADkjyNS9SOpXrKgD5wESrQc92aw+B4D1SgUL8gSju2je/WzVlBViEBlol/TxgxSssZ3uw2sVtuewubs9FXRUaao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736741715; c=relaxed/simple;
	bh=jHjRZxCQI8lPKuUYec8sOgkc49/Ac2ASU2a6uTEMSMg=;
	h=Date:To:From:Subject:Message-Id; b=aWd3IhAuGEjt2EQ+T6Htr9Dad4IkvFTE7ugfyTy8QJF5hDdzAqev0dIzmKTMe2CHTc0CajFmL70bP+HcZcmQzKUWcX4kOdiA9jC66ldCuxJ5nqtKu8xRPri/fOAx092tUwKdxjWZ5N/v2PfjssAvA0SnfVUS5j8UCIUduHrN/Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LzDA9eZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LzDA9eZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698ACC4CED6;
	Mon, 13 Jan 2025 04:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736741713;
	bh=jHjRZxCQI8lPKuUYec8sOgkc49/Ac2ASU2a6uTEMSMg=;
	h=Date:To:From:Subject:From;
	b=LzDA9eZV5KvR5sTZsZTi+HDOVIFBTlfM9bDNO/vWSb/j0fsuNTVQT0ELP3Yeiv1m4
	 rq4bchhmYwTOy1mgo1mAqrTTZGbQbX5LOP84Xs5BaRs54qVMPXmvlRRDaqIfgNBJd9
	 uynC/gX2rgQRIdFY4OthBYSSvJZXVoSTlJEkM1vs=
Date: Sun, 12 Jan 2025 20:15:12 -0800
To: mm-commits@vger.kernel.org,eahariha@linux.microsoft.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] s390-kernel-convert-timeouts-to-use-secs_to_jiffies-fix.patch removed from -mm tree
Message-Id: <20250113041513.698ACC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390-kernel-convert-timeouts-to-use-secs_to_jiffies-fix
has been removed from the -mm tree.  Its filename was
     s390-kernel-convert-timeouts-to-use-secs_to_jiffies-fix.patch

This patch was dropped because it was folded into s390-kernel-convert-timeouts-to-use-secs_to_jiffies.patch

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: s390-kernel-convert-timeouts-to-use-secs_to_jiffies-fix
Date: Tue, 17 Dec 2024 18:31:16 +0100

simplify cmm_set_timer()

Link: https://lkml.kernel.org/r/Z2G1ZPL2cAlQOYlF@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Easwar Hariharan <eahariha@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/cmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/mm/cmm.c~s390-kernel-convert-timeouts-to-use-secs_to_jiffies-fix
+++ a/arch/s390/mm/cmm.c
@@ -204,7 +204,7 @@ static void cmm_set_timer(void)
 			del_timer(&cmm_timer);
 		return;
 	}
-	mod_timer(&cmm_timer, jiffies + msecs_to_jiffies(cmm_timeout_seconds * MSEC_PER_SEC));
+	mod_timer(&cmm_timer, jiffies + secs_to_jiffies(cmm_timeout_seconds));
 }
 
 static void cmm_timer_fn(struct timer_list *unused)
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

s390-kernel-convert-timeouts-to-use-secs_to_jiffies.patch

