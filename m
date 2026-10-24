Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832331;
	b=D8BNB/k3XM1t6+qshu7rn19OshX52sbbm+l8rLGnUaN4m27y/557WRq+TZTQWlYGCEM7
	 L8qO9MN8F1ERUe9fDhZn3moIl9AynrtWoompdZnW88JzGw+j9N8Jdy2kfZdU8a8oydr9Y
	 CDi81urXFh6yy/u4bdKeYCHOccSMxkGIPNWWtgtl960vgXPmKe1o9e2PmS8L3W2OYA/nR
	 IOZGphczTdwDgyYnO5Vwm6JvFYfKYGrTgx+RBBOLguzqyQW1eIQ+6kHAz7JE5HQBFp76c
	 fUdUmU2N41RL0QFcLFrhq8b0HjyGwEwdoOm8gnOOkmzEJdeE26RrMi1zQEw8AcT7rxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832331;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=9XMVC+4jNaIkHt0O1nUKapTnN2YPtQI7MYHsjcqvOS4=;
	b=gNUnMaqKGZ8gpNkH2kOrpg2TcznH0m7Upor5C+vxgblC3TuOXC4LdLwjQRyJoSIfRI1P
	 HP8GZ5wFADkaC0SxhB4evqiCfn8yJTOAPv7jwXtoFMpamCNM3im9W5nQ/QlSCNJIxA7cH
	 QXVLvS89tTPwTzxa6KZv0iCge9ghl/4XNOOI94EOybphmKwEQ5Ww+yhy1FWBjWgIC8esU
	 1ODaMSr/M0BYtM75/NstIWKe7B54wQi1tr1bCr6WqJgInUkKnTfoYwx4qu/LVYB6Do9dp
	 UgVB3FtE+4WNyE279kzLPLPO15SuargJchgl34q4lHC2J3IEBLFZ0IRkZbbWpJi3UUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dYaoaMhT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3022F606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dYaoaMhT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE98B1F01828;
	Sat, 24 Oct 2026 08:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832331;
	bh=9XMVC+4jNaIkHt0O1nUKapTnN2YPtQI7MYHsjcqvOS4=;
	h=Date:To:From:Subject;
	b=dYaoaMhTMUpsjEJxe5+6iw6z627EeuoUmrjt3zHsGY0cKkiWYGFBlx3GOGh0dAHhE
	 UHmltBdWPc2T76F1t14HqluKR7tYjR3UtCz6TF60aJ0kdnd/bXAACWgGofUz9OA+T+
	 jaioqVatgGFaOJTk0YHfIZ6bXjdAL/r3aXGtWJ+M=
Date: Sat, 24 Oct 2026 01:58:50 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] init-kconfig-drop-arch_want_numa_variable_locality.patch removed from -mm tree
Message-Id: <20261024085850.EE98B1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: init/Kconfig: drop ARCH_WANT_NUMA_VARIABLE_LOCALITY
has been removed from the -mm tree.  Its filename was
     init-kconfig-drop-arch_want_numa_variable_locality.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: init/Kconfig: drop ARCH_WANT_NUMA_VARIABLE_LOCALITY
Date: Sun, 10 May 2026 16:55:43 +0300

sh was the only architecture that selected ARCH_WANT_NUMA_VARIABLE_LOCALITY.

With NUMA support on sh gone, there is no need in this configuration
option.

Remove it.

Link: https://lore.kernel.org/20260510135546.13554-8-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---

 init/Kconfig |    7 -------
 1 file changed, 7 deletions(-)

--- a/init/Kconfig~init-kconfig-drop-arch_want_numa_variable_locality
+++ a/init/Kconfig
@@ -1017,17 +1017,10 @@ config CC_STRINGOP_OVERFLOW
 config ARCH_SUPPORTS_INT128
 	bool
 
-# For architectures that (ab)use NUMA to represent different memory regions
-# all cpu-local but of different latencies, such as SuperH.
-#
-config ARCH_WANT_NUMA_VARIABLE_LOCALITY
-	bool
-
 config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
 	depends on ARCH_HAS_PTE_PROTNONE
-	depends on !ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	depends on SMP && NUMA_MIGRATION && !PREEMPT_RT
 	help
 	  This option adds support for automatic NUMA aware memory/task placement.
_

Patches currently in -mm which might be from rppt@kernel.org are


