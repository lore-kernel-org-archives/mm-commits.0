Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797D52DEA9B
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775236784; cv=none; b=rY7a59obQGweOc7O/UuioK36qbHC+86rXsWIqmqXKNzJqwNqz/qOoxUXM8i/Scwr5dSsn1UCDxl69j3tSMebZcKC2qQAU0KlXl2E4xJQzYgFn0butJY2K1NxMxbKaFgsu5ZaE7v/hNm2g0Db3GWKG5NUYDLWDHLL2xItsj/jGEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775236784; c=relaxed/simple;
	bh=oZH0ulfg2d8RAuSArHiOSEHlThckpRsASClNeGut+28=;
	h=Date:To:From:Subject:Message-Id; b=pGCeopsg/Bix7QqPh96XQ+GxF0FFxZBV5VPMTrUINd09avXxQwkdkxlfxKihnEmO9qxLi3Hbj3rcr30y6go4LlCQWKvjP5MqCugaaItYEYNADvCeJYWIWNbBLXdpfN8eZE/AukGq/AvWz3AkwRXF9/rkMwkZXhNKO48yCx9p/1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0lDT5kne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0lDT5kne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02321C4CEF7;
	Fri,  3 Apr 2026 17:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775236784;
	bh=oZH0ulfg2d8RAuSArHiOSEHlThckpRsASClNeGut+28=;
	h=Date:To:From:Subject:From;
	b=0lDT5kne4/Or+gSdiPINkY57GewocpkFpXuY6gomVe/eCkIFjNPmJvw1OqgKu/JBb
	 U5g0N7YTin3At/xtuCSwGNVDh2xzvCJ0KozQMQkNiySfQtdi+mk7rl+IjL322gqTLf
	 LNG1Hog2YraoJdMy2BhaXrfQ91pxssCCBa/OPZco=
Date: Fri, 03 Apr 2026 10:19:43 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,leotimmins1974@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] liveupdate-initialize-incoming-flb-state-before-finish-fix.patch removed from -mm tree
Message-Id: <20260403171944.02321C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate-initialize-incoming-flb-state-before-finish-fix
has been removed from the -mm tree.  Its filename was
     liveupdate-initialize-incoming-flb-state-before-finish-fix.patch

This patch was dropped because it was folded into liveupdate-initialize-incoming-flb-state-before-finish.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: liveupdate-initialize-incoming-flb-state-before-finish-fix
Date: Fri Mar 27 05:21:05 PM PDT 2026

remove unneeded braces, per Pasha

Cc: Leo Timmins <leotimmins1974@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_flb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/liveupdate/luo_flb.c~liveupdate-initialize-incoming-flb-state-before-finish-fix
+++ a/kernel/liveupdate/luo_flb.c
@@ -210,9 +210,8 @@ static void luo_flb_file_finish_one(stru
 		}
 	}
 
-	scoped_guard(mutex, &private->incoming.lock) {
+	scoped_guard(mutex, &private->incoming.lock)
 		count = --private->incoming.count;
-	}
 
 	if (!count) {
 		struct liveupdate_flb_op_args args = {0};
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

liveupdate-initialize-incoming-flb-state-before-finish.patch

