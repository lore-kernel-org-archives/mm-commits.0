Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1D2423EA9
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816299; cv=none; b=WY9NXB62a+FyoGMZD+Yo+qKn2Wk6DT2pUcqZiDYkdGSRLJLMjmOiAHhyW/+k88ka1KYCCzQVnLoSGyHn/6GN4ymO6WBerJAYs+4NPpME+YMV5cnUugcT2uAuIeCvPxvl8cATA6FgdO31S8NQ4dbJonKGikm3U+d9ZEtteW5qxek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816299; c=relaxed/simple;
	bh=eFsN/YAVT0hRFDVwcQDJ5JiymYQSaGFo9cscNuhKSNw=;
	h=Date:To:From:Subject:Message-Id; b=LAQRHfnoPTsNY2RIkUlIWYMnOyxrnRTmncEZ6f48AiyR2LrCkpU8hzO9ZLnK0WGsIeh+bWnpFhlGN48yo+PCq899ibrbXMvaDzdXgQ+iiTdakXxgT788VyQvWtYs4f4EIx5+HoJOogTfUrIv+98S0FPiw6JhTcdaPdkG1DALEno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y8DyuZnK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y8DyuZnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F1D1F000E9;
	Tue,  4 Aug 2026 04:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816297;
	bh=mLZ8SzL25sggLdqYxDTD7UhR0iuhFGjp/pMIcKIUr2k=;
	h=Date:To:From:Subject;
	b=Y8DyuZnKEdDJoe+zVQXN1Uxa99m52YkbqrcGRYQRUATQAeBbfZWhZdLBzVUpRK1LQ
	 ckUo3pw44YOkBVzNLW34LUwU1H/0bASCf/DmS66U3Jaefh49SMfAMuD+AqMSCJADi/
	 KCJZrXJo+P4o0rKBHiPmDzsIQLe8LCX2g1XKJ/qc=
Date: Mon, 03 Aug 2026 21:04:57 -0700
To: mm-commits@vger.kernel.org,wang.yaxin@zte.com.cn,fan.yu9@zte.com.cn,sarasena.adr@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-accounting-delaytopc-fix-typo-in-psi-header-string.patch removed from -mm tree
Message-Id: <20260804040457.D3F1D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/accounting/delaytop.c: fix typo in PSI header string
has been removed from the -mm tree.  Its filename was
     tools-accounting-delaytopc-fix-typo-in-psi-header-string.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sara Sena <sarasena.adr@gmail.com>
Subject: tools/accounting/delaytop.c: fix typo in PSI header string
Date: Tue, 30 Jun 2026 22:11:53 -0300

Link: https://lore.kernel.org/20260701011153.93426-1-sarasena.adr@gmail.com
Signed-off-by: Sara Sena <sarasena.adr@gmail.com>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/delaytop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/accounting/delaytop.c~tools-accounting-delaytopc-fix-typo-in-psi-header-string
+++ a/tools/accounting/delaytop.c
@@ -878,7 +878,7 @@ static void display_results(int psi_ret)
 	suc &= BOOL_FPRINT(out, "\033[H\033[J");
 
 	/* PSI output (one-line, no cat style) */
-	suc &= BOOL_FPRINT(out, "System Pressure Information: (avg10/avg60vg300/total)\n");
+	suc &= BOOL_FPRINT(out, "System Pressure Information: (avg10/avg60/avg300/total)\n");
 	if (psi_ret) {
 		suc &= BOOL_FPRINT(out, "  PSI not found: check if psi=1 enabled in cmdline\n");
 	} else {
_

Patches currently in -mm which might be from sarasena.adr@gmail.com are


