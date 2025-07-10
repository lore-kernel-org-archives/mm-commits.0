Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F068469D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122395; cv=none; b=YcpS8SvLZmiKGtNPe+V1WF6zk1N1Jn9y+7goX23TOT6cv97d1UH1i/Vx0dbbfiSF39cjlMk0cNcE3CP0TxC4GofwBAaSTsfVaZLg+LIoDbB6r5cRrKPxlSTlqdOTWfoqE/mQt/azszVUua8c3fIIWiHkuC22vUdPfdoAmqboJjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122395; c=relaxed/simple;
	bh=a4plzGE2+7Ovl1AvkWXB6t+n49wq+tDfi/TfKNF8t6c=;
	h=Date:To:From:Subject:Message-Id; b=qWjMxXHc0I73xvy5memRizHVHbZ7do5hRseJ9soFfM4KHmBxuW3JCQMdEOuVZxMgy7DzNztu/FdTCQ4lRd/TbiVVDjGgF6a5bnX2OsJkoA/CCK9m1DrLJNul2h+P2F7kDR+y274XaTdWZgm+mL9HWbigTFgVXpM0bjD7GxRQzy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KkRgL9og; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KkRgL9og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76158C4CEE3;
	Thu, 10 Jul 2025 04:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122394;
	bh=a4plzGE2+7Ovl1AvkWXB6t+n49wq+tDfi/TfKNF8t6c=;
	h=Date:To:From:Subject:From;
	b=KkRgL9ogidJqDccK0R/2G9fAqzsnaeikyfbgXzRpPlPUDoHSj8cnpo71mb/gDjilM
	 Di6odTvBMHwc7W/sqRtTYdzPeitNsdluFJZhNMCTbPzg66JLp1Azf0Le5v0tIufTVu
	 zXDvDF/65wEJ+mPyMe33/hhaA4WCwLvrHWIFfNaU=
Date: Wed, 09 Jul 2025 21:39:53 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] gup-optimize-longterm-pin_user_pages-for-large-folio-fix.patch removed from -mm tree
Message-Id: <20250710043954.76158C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: gup-optimize-longterm-pin_user_pages-for-large-folio-fix
has been removed from the -mm tree.  Its filename was
     gup-optimize-longterm-pin_user_pages-for-large-folio-fix.patch

This patch was dropped because it was folded into gup-optimize-longterm-pin_user_pages-for-large-folio.patch

------------------------------------------------------
From: Li Zhe <lizhe.67@bytedance.com>
Subject: gup-optimize-longterm-pin_user_pages-for-large-folio-fix
Date: Fri, 6 Jun 2025 17:19:17 +0800

whitespace fix, per David

Link: https://lkml.kernel.org/r/20250606091917.91384-1-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~gup-optimize-longterm-pin_user_pages-for-large-folio-fix
+++ a/mm/gup.c
@@ -2334,7 +2334,7 @@ static unsigned long collect_longterm_un
 	long i = 0;
 
 	for (folio = pofs_get_folio(pofs, i); folio;
-		 folio = pofs_next_folio(folio, pofs, &i)) {
+	     folio = pofs_next_folio(folio, pofs, &i)) {
 
 		if (folio_is_longterm_pinnable(folio))
 			continue;
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

gup-optimize-longterm-pin_user_pages-for-large-folio.patch

