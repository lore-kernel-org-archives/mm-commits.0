Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1869623776
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 03:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716519609; cv=none; b=bDmMBS6vqPDxXVq95EqEq/t+9Ss6LgxRic5HETyqPP3HMu0gjwO6N/43YieoRCOksXXQHOWF4I6aLfSdnswCThZYdl20Midi6f3B9LSkaU1wfs8QTTnG+BE986566ZHn5meV9qujRm9SM0v94NKENa6P1GAsLZBl2kafafjS4+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716519609; c=relaxed/simple;
	bh=r6fBk9y/KrPYDMWWeyl4tPdIM0PgnBZj7lqpXOOBKjw=;
	h=Date:To:From:Subject:Message-Id; b=FPTzqUG2Hzl5i+58qfsB4v3xgOK8Ci+RlY4G1wdd5XHoXzvBRth9yKrD1DgKncYKwaaGb5PYsgrI7/90kfgHZ7HX9NK3EA74ki2sVWNoJfg/rX4LtIqaRqTnOwcQsdml7+2s8QUA6igMVzwEVozKyvS1ncE/o8mH7Zh4R0NXk20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X6RwRglw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X6RwRglw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A1AC2BD10;
	Fri, 24 May 2024 03:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716519608;
	bh=r6fBk9y/KrPYDMWWeyl4tPdIM0PgnBZj7lqpXOOBKjw=;
	h=Date:To:From:Subject:From;
	b=X6RwRglwAp3iLolyuDl03Na4RWbHujNK1UspsG6nj0XXoV2Rn+uH0fOvAHZJiuKy7
	 WUOdROv08G/onxpoO5O6oQKd1YwfJy6euQv81SprRCassl5toFfLyeeMKAO5Mm9x14
	 JYo0//KZ/B2wnQHR4le4BFU9fZEw7krhsflhfcmY=
Date: Thu, 23 May 2024 20:00:07 -0700
To: mm-commits@vger.kernel.org,yoann.congal@smile.fr,vincent.guittot@linaro.org,rdunlap@infradead.org,pmladek@suse.com,nphamcs@gmail.com,masahiroy@kernel.org,gustavoars@kernel.org,davem@davemloft.net,arnd@arndb.de,aleksander.lobakin@intel.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gcc-disable-warray-bounds-for-gcc-9.patch added to mm-hotfixes-unstable branch
Message-Id: <20240524030008.78A1AC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: gcc: disable '-Warray-bounds' for gcc-9
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     gcc-disable-warray-bounds-for-gcc-9.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gcc-disable-warray-bounds-for-gcc-9.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

gcc-disable-warray-bounds-for-gcc-9.patch

