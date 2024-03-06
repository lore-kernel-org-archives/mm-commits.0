Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79D2179B1
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759296; cv=none; b=Xo3VKuSupfrODOeUAUK4jPkheHh+WvDKzgOz8BqxX+dulVq7A/zEBvPQtOHbey85s1sm9lKL5q1WjpH2HevQYoxig4zxeHq1uOaRB/jg2sxm+udGuOvxLJfIDQxfsxMFQ9tGW0P6Giq8y3Yb55jQHqqa0Ym65eP9uviuHugJ/GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759296; c=relaxed/simple;
	bh=zAQ4FCtgVDVwW5pLPApu8MPJpuwok2qfAnU6TnCBLIk=;
	h=Date:To:From:Subject:Message-Id; b=RqQGL4ULXJ9WtW/Fbay+I6llQP4K3AKlkV7kkR7ctok0wBGUPJf6pfnTU/Ypc6Q90MUy40QcKkXXDtCKLVRf4XA0qcSmQthJOJlWC7iGFMiiEZlGsjsMNhLbAlmA1gZJbfTXDkuIwp2i+sMjdw+psdp6ZezcfOyFUCEhNmyIYzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gVQtji9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gVQtji9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A276C43399;
	Wed,  6 Mar 2024 21:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759296;
	bh=zAQ4FCtgVDVwW5pLPApu8MPJpuwok2qfAnU6TnCBLIk=;
	h=Date:To:From:Subject:From;
	b=gVQtji9Eu+AIVbG8kW00eTRcY9NWXtI+aPwEOCia8+qPQUxdXy7k4Grw3NkNPpGhL
	 iEhZgVjuzkdA+05V2p3EV1EMdbVOd+NIjTEUvyh4jV3jNGAX3qgwYc7hI7DpzQR284
	 /MyHR1R8ciA06AcpbY2+kodVZGOnf3+R/jQEz41Q=
Date: Wed, 06 Mar 2024 13:08:15 -0800
To: mm-commits@vger.kernel.org,bhe@redhat.com,yang.zhang@hexintek.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-copy-only-happens-before-uchunk-goes-to-zero.patch removed from -mm tree
Message-Id: <20240306210816.5A276C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: copy only happens before uchunk goes to zero
has been removed from the -mm tree.  Its filename was
     kexec-copy-only-happens-before-uchunk-goes-to-zero.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "yang.zhang" <yang.zhang@hexintek.com>
Subject: kexec: copy only happens before uchunk goes to zero
Date: Thu, 22 Feb 2024 17:21:19 +0800

When loading segments, ubytes is <= mbytes.  When ubytes is exhausted,
there could be remaining mbytes.  Then in the while loop, the buf pointer
advancing with mchunk will causing meaningless reading even though it
doesn't harm.

So let's change to make sure that all of the copying and the rest only
happens before uchunk goes to zero.

Link: https://lkml.kernel.org/r/20240222092119.5602-1-gaoshanliukou@163.com
Signed-off-by: yang.zhang <yang.zhang@hexintek.com>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   44 ++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

--- a/kernel/kexec_core.c~kexec-copy-only-happens-before-uchunk-goes-to-zero
+++ a/kernel/kexec_core.c
@@ -800,22 +800,24 @@ static int kimage_load_normal_segment(st
 				PAGE_SIZE - (maddr & ~PAGE_MASK));
 		uchunk = min(ubytes, mchunk);
 
-		/* For file based kexec, source pages are in kernel memory */
-		if (image->file_mode)
-			memcpy(ptr, kbuf, uchunk);
-		else
-			result = copy_from_user(ptr, buf, uchunk);
+		if (uchunk) {
+			/* For file based kexec, source pages are in kernel memory */
+			if (image->file_mode)
+				memcpy(ptr, kbuf, uchunk);
+			else
+				result = copy_from_user(ptr, buf, uchunk);
+			ubytes -= uchunk;
+			if (image->file_mode)
+				kbuf += uchunk;
+			else
+				buf += uchunk;
+		}
 		kunmap_local(ptr);
 		if (result) {
 			result = -EFAULT;
 			goto out;
 		}
-		ubytes -= uchunk;
 		maddr  += mchunk;
-		if (image->file_mode)
-			kbuf += mchunk;
-		else
-			buf += mchunk;
 		mbytes -= mchunk;
 
 		cond_resched();
@@ -866,11 +868,18 @@ static int kimage_load_crash_segment(str
 			memset(ptr + uchunk, 0, mchunk - uchunk);
 		}
 
-		/* For file based kexec, source pages are in kernel memory */
-		if (image->file_mode)
-			memcpy(ptr, kbuf, uchunk);
-		else
-			result = copy_from_user(ptr, buf, uchunk);
+		if (uchunk) {
+			/* For file based kexec, source pages are in kernel memory */
+			if (image->file_mode)
+				memcpy(ptr, kbuf, uchunk);
+			else
+				result = copy_from_user(ptr, buf, uchunk);
+			ubytes -= uchunk;
+			if (image->file_mode)
+				kbuf += uchunk;
+			else
+				buf += uchunk;
+		}
 		kexec_flush_icache_page(page);
 		kunmap_local(ptr);
 		arch_kexec_pre_free_pages(page_address(page), 1);
@@ -878,12 +887,7 @@ static int kimage_load_crash_segment(str
 			result = -EFAULT;
 			goto out;
 		}
-		ubytes -= uchunk;
 		maddr  += mchunk;
-		if (image->file_mode)
-			kbuf += mchunk;
-		else
-			buf += mchunk;
 		mbytes -= mchunk;
 
 		cond_resched();
_

Patches currently in -mm which might be from yang.zhang@hexintek.com are


