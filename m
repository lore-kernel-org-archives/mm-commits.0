Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C865836164E
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388530; cv=none; b=AC292T2e/1tdG/x/5xzKZvV74CZCVtMENmSeTBMALu44DYs9sI32kprO3O0oUJU6nm+d31ixTtTH46A/BLPd2kdLZQFCVRex+vxfoItQePkzIepfKTu8yQMVgEiwEsdwp3L/VwTiqSR6K4ybVEuIESZDshy+6DBEPIOZ2sgAbmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388530; c=relaxed/simple;
	bh=P34Tx5azp81qS6YJt9yg4vPJA8+NySpKoajYj1RwBUY=;
	h=Date:To:From:Subject:Message-Id; b=dcg0nOwb9rbNMqCBmaO2nvffXo6SROzEtkq4TxriayMwr1l3PuLA47g3yjl0VVCjtyQRuWnl77peTppVWhSinI2rw7Q2zq9pY6hDodqBJOlGRf2gAeRkJf/tB2fALroZmlybtFzMaZp+cux2MSWpVrVNu95a+aUQgG36C6F41FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hl3KVeKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hl3KVeKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F91BC2BCB2;
	Tue, 24 Mar 2026 21:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388530;
	bh=P34Tx5azp81qS6YJt9yg4vPJA8+NySpKoajYj1RwBUY=;
	h=Date:To:From:Subject:From;
	b=hl3KVeKEHZtDA8eA9284Dc7G4O/8JhhF/Xz368idBizeyQL4PqU9VTKBQTYOB8F0E
	 PSlxNB3L2ocfyFBAmjhIXSrRwHlCZqsWbA3Fktsy04l1jI3Th6DQxgdLGHU7Sddhsv
	 KTcooc2EXSOxNmLOurJou7QzGTOeIcPRvsjzbyys=
Date: Tue, 24 Mar 2026 14:42:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-dont-pass-end-to-mas_wr_append.patch removed from -mm tree
Message-Id: <20260324214210.9F91BC2BCB2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: don't pass end to mas_wr_append()
has been removed from the -mm tree.  Its filename was
     maple_tree-dont-pass-end-to-mas_wr_append.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: don't pass end to mas_wr_append()
Date: Fri, 30 Jan 2026 15:59:34 -0500

Figure out the end internally.  This is necessary for future cleanups.

Link: https://lkml.kernel.org/r/20260130205935.2559335-30-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/lib/maple_tree.c~maple_tree-dont-pass-end-to-mas_wr_append
+++ a/lib/maple_tree.c
@@ -3309,18 +3309,17 @@ static inline unsigned char mas_wr_new_e
 /*
  * mas_wr_append: Attempt to append
  * @wr_mas: the maple write state
- * @new_end: The end of the node after the modification
  *
  * This is currently unsafe in rcu mode since the end of the node may be cached
  * by readers while the node contents may be updated which could result in
  * inaccurate information.
  */
-static inline void mas_wr_append(struct ma_wr_state *wr_mas,
-		unsigned char new_end)
+static inline void mas_wr_append(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
 	void __rcu **slots;
 	unsigned char end = mas->end;
+	unsigned char new_end = mas_wr_new_end(wr_mas);
 
 	if (new_end < mt_pivots[wr_mas->type]) {
 		wr_mas->pivots[new_end] = wr_mas->pivots[end];
@@ -3513,7 +3512,7 @@ static inline void mas_wr_store_entry(st
 			mas_update_gap(mas);
 		break;
 	case wr_append:
-		mas_wr_append(wr_mas, new_end);
+		mas_wr_append(wr_mas);
 		break;
 	case wr_slot_store:
 		mas_wr_slot_store(wr_mas);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


