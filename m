Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA5120694D
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 20:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729283739; cv=none; b=DhHAC5DsipMfRr0LCXprBJZ4+s9n1EQyLzGdgEusaqzBR8CI2Sf0CoxQIJ9lmsxhIJBnaHt6Jayh9GUpRKXA7Kk1RAQoNUPrpf7sXweeqF/5uYlJapGOLBjlA+QIigyP4UWX5GGsd6UgRO74ubaZPyvVtcDd1F66Lnh+0LIggHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729283739; c=relaxed/simple;
	bh=BoKFJn1ELZov8cgPZ+LsR1WkAfwe0eCLxR7dKaAPyyI=;
	h=Date:To:From:Subject:Message-Id; b=DKGROdIESpEShWPzkKdGf70yKhTM3ivnIfyoTubJGBFZcE/rHTouYuSyq60hxl7oFf8QMovH/0fGbYi3ZZeboGRvwCA1BA6XJV/bR4k7/hIbSNaqOSx6KxvAAJin+XQmyIyz8aa6LojHmZQxQRfrpqfLIpzRS//Sz78QEX1AM8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vixV5T6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vixV5T6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C53C4CEC3;
	Fri, 18 Oct 2024 20:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729283738;
	bh=BoKFJn1ELZov8cgPZ+LsR1WkAfwe0eCLxR7dKaAPyyI=;
	h=Date:To:From:Subject:From;
	b=vixV5T6s/zDT02YTTpZEQdsELzgwnmf3H2tlz/xQbD5zEOAklzM2IEI/OQphu0J9m
	 oPevd7Mj51saekz4cQ8PqeIQ+xuD6uJkgKmZRPdPAU75WSn6bXDSzoNJYec3zqc7F9
	 sH0CM0DPexB9MdVOCZquNxUjOuF6DZwjYwi7ijN4=
Date: Fri, 18 Oct 2024 13:35:37 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-migrate-copy_user_test-to-kunit-fix.patch added to mm-unstable branch
Message-Id: <20241018203538.93C53C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: export copy_to_kernel_nofault
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-migrate-copy_user_test-to-kunit-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-migrate-copy_user_test-to-kunit-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: export copy_to_kernel_nofault
Date: Fri, 18 Oct 2024 15:11:09 +0000

This symbol is now used on the kasan test module, so it needs to be
exported.

ERROR: modpost: "copy_to_kernel_nofault" [mm/kasan/kasan_test.ko] undefined!

Link: https://lkml.kernel.org/r/20241018151112.3533820-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/maccess.c~kasan-migrate-copy_user_test-to-kunit-fix
+++ a/mm/maccess.c
@@ -82,6 +82,7 @@ Efault:
 	pagefault_enable();
 	return -EFAULT;
 }
+EXPORT_SYMBOL_GPL(copy_to_kernel_nofault);
 
 long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

bootmem-add-bootmem_type-stub-function-fix-2.patch
kasan-migrate-copy_user_test-to-kunit-fix.patch

