Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A022A1EB3D
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473427; cv=none; b=A1Xu6unpJH96I/NhJO9hcWkaVXwhRI+oaa/aAAB/1gb0VooJQY2OMlK8lGZPgLU14QWUT45129oO6MhkWXAPKdWzb7XdZjr/nAKZe/cF0wGm+SArs1WjtVBkVLkmmr9IbysWZvo10SDdrIqg9xCWadjm/Cey4DxXP2+ng/MLjT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473427; c=relaxed/simple;
	bh=sWZWkvbGM7WEyP2fTMFsjdHiyncDLzlioJJti6fVLvU=;
	h=Date:To:From:Subject:Message-Id; b=a0c93cXBNB/Mr2lkds36n/5a58yfZCdm7/voOyQ5IrO3vBwjpALMqZNWgTRZFzQQtgjVQMcpvCoIr+0F76H+pzKnpY4y6USdLOZ47YRLrrmJJwrI6t8r2LlyGb5Yn7mL2Ca9cr2pHlqi3LXmTq7FEokHosUmL/E4uMMNdg+pvHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XOu7tWmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XOu7tWmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBC4C3277B;
	Sat, 15 Jun 2024 17:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473427;
	bh=sWZWkvbGM7WEyP2fTMFsjdHiyncDLzlioJJti6fVLvU=;
	h=Date:To:From:Subject:From;
	b=XOu7tWmGFAj+dJcK4hxSOQ/A8P+gqzRDcOqFCH7JPqKZFo7Q5L3IgYX5IZBg0FkOw
	 /DlsM475hB6/iv50+650SwBSPf8JLRYSq718WrfXueFchkkbp2GGpUazoCwXIF+BWL
	 V+G9lgde2xLiiSipHVZEuOYpBKcKcpdGGNeJ6Glw=
Date: Sat, 15 Jun 2024 10:43:46 -0700
To: mm-commits@vger.kernel.org,yoann.congal@smile.fr,vincent.guittot@linaro.org,rdunlap@infradead.org,pmladek@suse.com,nphamcs@gmail.com,masahiroy@kernel.org,gustavoars@kernel.org,davem@davemloft.net,arnd@arndb.de,aleksander.lobakin@intel.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] gcc-disable-warray-bounds-for-gcc-9.patch removed from -mm tree
Message-Id: <20240615174347.1DBC4C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: gcc: disable '-Warray-bounds' for gcc-9
has been removed from the -mm tree.  Its filename was
     gcc-disable-warray-bounds-for-gcc-9.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: gcc: disable '-Warray-bounds' for gcc-9
Date: Wed, 22 May 2024 15:58:30 -0700

'-Warray-bounds' is already disabled for gcc-10+.  Now that we've merged
bitmap_{read,write), I see the following error when building the kernel
with gcc-9.4 (Ubuntu 20.04.4 LTS) for x86_64 allmodconfig:

drivers/pinctrl/pinctrl-cy8c95x0.c: In function `cy8c95x0_read_regs_mask.isra.0':
include/linux/bitmap.h:756:18: error: array subscript [1, 288230376151711744] is outside array bounds of `long unsigned int[1]' [-Werror=array-bounds]
  756 |  value_high = map[index + 1] & BITMAP_LAST_WORD_MASK(start + nbits);
      |               ~~~^~~~~~~~~~~

The immediate reason is that the commit b44759705f7d ("bitmap: make
bitmap_{get,set}_value8() use bitmap_{read,write}()") switched the
bitmap_get_value8() to an alias of bitmap_read(); the same for 'set'.

Now; the code that triggers Warray-bounds, calls the function like this:

  #define MAX_BANK 8
  #define BANK_SZ 8
  #define MAX_LINE        (MAX_BANK * BANK_SZ)
  DECLARE_BITMAP(tval, MAX_LINE); // 64-bit map: unsigned long tval[1]

  read_val |= bitmap_get_value8(tval, i * BANK_SZ) & ~bits;

bitmap_read() is implemented such that it may conditionally dereference a
pointer beyond the boundary like this:

	unsigned long offset = start % BITS_PER_LONG;
        unsigned long space = BITS_PER_LONG - offset;

        if (space >= nbits)
                return (map[index] >> offset) & BITMAP_LAST_WORD_MASK(nbits);

        value_low = map[index] & BITMAP_FIRST_WORD_MASK(start);
        value_high = map[index + 1] & BITMAP_LAST_WORD_MASK(start + nbits);
        return (value_low >> offset) | (value_high << space);

In case of bitmap_get_value8(), it's impossible to violate the boundary
because 'space >= nbits' is never the true for byte-aligned 8-bit access. 
So, this is clearly a false-positive.

The same type of false-positives break my allmodconfig build in many
places.  gcc-8, is clear, however.

Link: https://lkml.kernel.org/r/20240522225830.1201778-1-yury.norov@gmail.com
Fixes: b44759705f7d ("bitmap: make bitmap_{get,set}_value8() use bitmap_{read,write}()")
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Yoann Congal <yoann.congal@smile.fr>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/Kconfig~gcc-disable-warray-bounds-for-gcc-9
+++ a/init/Kconfig
@@ -883,7 +883,7 @@ config GCC10_NO_ARRAY_BOUNDS
 
 config CC_NO_ARRAY_BOUNDS
 	bool
-	default y if CC_IS_GCC && GCC_VERSION >= 100000 && GCC10_NO_ARRAY_BOUNDS
+	default y if CC_IS_GCC && GCC_VERSION >= 90000 && GCC10_NO_ARRAY_BOUNDS
 
 # Currently, disable -Wstringop-overflow for GCC globally.
 config GCC_NO_STRINGOP_OVERFLOW
_

Patches currently in -mm which might be from yury.norov@gmail.com are

maintainers-add-linux-nodemask_typesh-to-bitmap-api.patch
sched-avoid-using-ilog2-in-schedh.patch
sched-drop-schedh-dependency-on-cpumask.patch
cpumask-cleanup-core-headers-inclusion.patch
cpumask-make-core-headers-including-cpumask_typesh-where-possible.patch

