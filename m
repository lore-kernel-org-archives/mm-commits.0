Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C28D14A62A
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006499; cv=none; b=Af58rV78sEyLZIJ8DV4qAaeeCNENskpcfsPiiOVtisoiinT03Y5eoLFDvapWbmQGiJ601keihAEBEQDHRulDd19wXGJNKbr7yuU1CjgNZlpdXwlNGIqxf6rN+1+t42PR1eFxpx4lp4SZPW7x12mwrgRjABojJd5Zxc76YtOuAJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006499; c=relaxed/simple;
	bh=fKH5b6ctmrFBP18blem1qflM8cNq0aST1O2UY8Kq4lw=;
	h=Date:To:From:Subject:Message-Id; b=XUlpKet3NB65eaw8rAmk4uvCKAEgbn6s3dtBL7AcU3hVyBXNCOuSav25LmSgPehxgQyyhlSSyjSlTzzkaGuVE1BETsPtg6A0O1fOpaQUI1WdDgj+OQTwpI4apLeqxbialLuL5C34S5BwqZhMBOD4/P4v/TAYFoGjz68XaKkrjlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jF9hE9is; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jF9hE9is"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C62C4CED6;
	Thu, 16 Jan 2025 05:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006498;
	bh=fKH5b6ctmrFBP18blem1qflM8cNq0aST1O2UY8Kq4lw=;
	h=Date:To:From:Subject:From;
	b=jF9hE9isvp4PRG1kmWgRuKs0jU7eOSs1TLK7JGmt1i63DeyiDdeuKjs1T1vd8L0JU
	 pl0Sf3h8cF3mKp17wUlgA/5gcBKkyZQCiOGCGzZzOP1GJ7FuDj9ZU2rTruP9ewR5qz
	 iTkoxctO8fsU7PqJ9EjifHFG6Zb0EKJ9PmJzo2Pc=
Date: Wed, 15 Jan 2025 21:48:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xarray-use-xa_mark_t-in-xas_squash_marks-to-keep-code-consistent.patch removed from -mm tree
Message-Id: <20250116054818.A3C62C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Xarray: use xa_mark_t in xas_squash_marks() to keep code consistent
has been removed from the -mm tree.  Its filename was
     xarray-use-xa_mark_t-in-xas_squash_marks-to-keep-code-consistent.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: Xarray: use xa_mark_t in xas_squash_marks() to keep code consistent
Date: Fri, 13 Dec 2024 20:25:23 +0800

Besides xas_squash_marks(), all functions use xa_mark_t type to iterate
all possible marks.  Use xa_mark_t in xas_squash_marks() to keep code
consistent.

Link: https://lkml.kernel.org/r/20241213122523.12764-6-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Mattew Wilcox <willy@infradead.org>
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


