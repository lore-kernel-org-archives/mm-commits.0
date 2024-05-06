Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A7A25757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957082; cv=none; b=C49GG/EWauTT07u5gXQvsOgH3VV2N02eF0/O2M3NQKIrJMWVBWO+be9KJMz6aJ/4C8oEjLxLbYhMja2L+7KvLfbveMC28fHCsp05etJgygLeZ6J90kh5/IRzkwzGlciyFOoGb08/pOUvw329PlgosVg0IBG43YwQsCKr0lGdEWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957082; c=relaxed/simple;
	bh=MWuaP4PZ3n2E1Cx/c/Zxv7WBm/BREmdtVvbBxRGFC2k=;
	h=Date:To:From:Subject:Message-Id; b=YhIcs31sLENFXa7NVuQXScvFd2JSFZ2EinEYnzmY7/jtZgXu3VeT+rMh/JNYFQSolDaOAk7c+/Hy6N8Hp4J8Fh0IW4IEVOyLV/rAREoVhPUnjmAVmoxhNQoshykQMKcSS/uqiHWgztiXGznla54+h/uERUN8fu3omliRmrOs7tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gEOnq+89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gEOnq+89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC2CC113CC;
	Mon,  6 May 2024 00:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957081;
	bh=MWuaP4PZ3n2E1Cx/c/Zxv7WBm/BREmdtVvbBxRGFC2k=;
	h=Date:To:From:Subject:From;
	b=gEOnq+89nhesg2daJjk7laGdtj2sznM6ZoVoMKLkTyLbxJ1HZ7YNiUiwxMZO/BOYr
	 Wke277wwAXv3Xg6QnY4vQaGH3zV2J1zpI4J7Qsh8jBeLFeP4IYEw2KmuDBoA0AscKE
	 tO7G1/i/hxUmxi9o92yQfJu6PdpWbFmk471qmNyc=
Date: Sun, 05 May 2024 17:58:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xarray-use-bits_per_longs.patch removed from -mm tree
Message-Id: <20240506005801.CFC2CC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xarray: use BITS_PER_LONGS()
has been removed from the -mm tree.  Its filename was
     xarray-use-bits_per_longs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: xarray: use BITS_PER_LONGS()
Date: Tue, 23 Apr 2024 17:20:24 +0300

Patch series "xarray: Clean up xarray.h".

Main portion of this change is to get rid of kernel.h included into other
globally available headers.  This decreases a dependency hell degree.  The
first patch makes it possible to avoid math.h to be included as bitops.h
is implied by bitmap.h.


This patch (of 2):

Use BITS_PER_LONGS() instead of open coded variant.

Link: https://lkml.kernel.org/r/20240423142204.2408923-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xarray.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/xarray.h~xarray-use-bits_per_longs
+++ a/include/linux/xarray.h
@@ -1146,7 +1146,7 @@ static inline void xa_release(struct xar
 #define XA_CHUNK_SIZE		(1UL << XA_CHUNK_SHIFT)
 #define XA_CHUNK_MASK		(XA_CHUNK_SIZE - 1)
 #define XA_MAX_MARKS		3
-#define XA_MARK_LONGS		DIV_ROUND_UP(XA_CHUNK_SIZE, BITS_PER_LONG)
+#define XA_MARK_LONGS		BITS_TO_LONGS(XA_CHUNK_SIZE)
 
 /*
  * @count is the count of every non-NULL element in the ->slots array
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

media-rc-add-missing-ioh.patch
media-stih-cec-add-missing-ioh.patch
kfifo-dont-use-proxy-headers.patch

