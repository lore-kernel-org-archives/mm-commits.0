Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675168F5E
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 04:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734062472; cv=none; b=Hh99vNVkOZlsbuYd19TaZgc59zEAbsttsjIdytQGgtAr4yXpcCnbfJ4hVr4djSqbJ+TStyHagPOpA8jxPlYHajWxXwG4zV0IRw3Qm/oWW+x2ZVea6ojTHxtzkQPYoKCYIYhhvn6zM2IMEy2Uv1soaL1rK8SmiwkvsmWtldSINys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734062472; c=relaxed/simple;
	bh=k6gq/FPtclr/7+xDhvgnJSU90/GlP34ekQFNRWiclJE=;
	h=Date:To:From:Subject:Message-Id; b=KmHwu2AJavgVlWhoTUwEtTcI/r9hWX3oZoUI+HhGPS1EbBqbp+ZEFU2VXnxPVSWoSboBBrhVEccYJP/boAE+T4Ya8F6r4l1HRPtcuveRslkT93uAVRTl6nV9V8TFSdZDfXlSy+iC7v35Xr8OupX/UUiGs0VHILJg1e01EPXbBns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CeAH089s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CeAH089s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64C7C4CED2;
	Fri, 13 Dec 2024 04:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734062471;
	bh=k6gq/FPtclr/7+xDhvgnJSU90/GlP34ekQFNRWiclJE=;
	h=Date:To:From:Subject:From;
	b=CeAH089sZ0dbvcxMG/t26W491MurUTCFBP0wgih65x3+iLzxxVbH3LDFflT5wv0Ef
	 VgV61Cyr/D8cEQYzezRx33os9FwC5meLKuveiweSZX39hvhzzkn3/CWzpcsuTKPDYa
	 ctMQsJVcGWXBOIUiXLEvZGMxBHww6LGmSPGjYmno=
Date: Thu, 12 Dec 2024 20:01:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-use-xa_mark_t-in-xas_squash_marks-to-keep-code-consistent.patch added to mm-nonmm-unstable branch
Message-Id: <20241213040111.D64C7C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Xarray: use xa_mark_t in xas_squash_marks() to keep code consistent
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xarray-use-xa_mark_t-in-xas_squash_marks-to-keep-code-consistent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-use-xa_mark_t-in-xas_squash_marks-to-keep-code-consistent.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: Xarray: use xa_mark_t in xas_squash_marks() to keep code consistent
Date: Fri, 13 Dec 2024 20:25:23 +0800

Besides xas_squash_marks(), all functions use xa_mark_t type to iterate
all possible marks.  Use xa_mark_t in xas_squash_marks() to keep code
consistent.

Link: https://lkml.kernel.org/r/20241213122523.12764-6-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/lib/xarray.c~xarray-use-xa_mark_t-in-xas_squash_marks-to-keep-code-consistent
+++ a/lib/xarray.c
@@ -125,16 +125,20 @@ static inline void node_mark_all(struct
  */
 static void xas_squash_marks(const struct xa_state *xas)
 {
-	unsigned int mark = 0;
+	xa_mark_t mark = 0;
 	unsigned int limit = xas->xa_offset + xas->xa_sibs + 1;
 
-	do {
-		unsigned long *marks = xas->xa_node->marks[mark];
-		if (find_next_bit(marks, limit, xas->xa_offset + 1) == limit)
-			continue;
-		__set_bit(xas->xa_offset, marks);
-		bitmap_clear(marks, xas->xa_offset + 1, xas->xa_sibs);
-	} while (mark++ != (__force unsigned)XA_MARK_MAX);
+	for (;;) {
+		unsigned long *marks = node_marks(xas->xa_node, mark);
+
+		if (find_next_bit(marks, limit, xas->xa_offset + 1) != limit) {
+			__set_bit(xas->xa_offset, marks);
+			bitmap_clear(marks, xas->xa_offset + 1, xas->xa_sibs);
+		}
+		if (mark == XA_MARK_MAX)
+			break;
+		mark_inc(mark);
+	}
 }
 
 /* extracts the offset within this node from the index */
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

xarray-do-not-return-sibling-entries-from-xas_find_marked.patch
xarray-move-forward-index-correctly-in-xas_pause.patch
xarray-distinguish-large-entries-correctly-in-xas_split_alloc.patch
xarray-remove-repeat-check-in-xas_squash_marks.patch
xarray-use-xa_mark_t-in-xas_squash_marks-to-keep-code-consistent.patch

