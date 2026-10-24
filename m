Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792828030;
	b=oVDPDm8fTXNmUduH7F60M6o00vjvan7mbFb5fMnpVpKWtZBB3WWxG/M8vu2d3etR+YSv
	 kPfOYepGRESaRvKtDTDvr6FmRcpnAoSPo3m8blGiuUp0xfHtZFCsloQZCZ+dltEKIiRk8
	 C0/MK/RwhWGn3kmI7X+8pW1pPcsOpVB7COwbPvUsrjfVT7yl/RadvHa9BJaYppqhDv0SV
	 8LwQhbtjI3e/E/OQsgp1vERasY64j8tk1vzJrB4lUxH3ytBrRFh6W5kKvFMesuM3XyVv7
	 PU2HiRV5by2zR/PjJcwJl50dWFMU2UkjEDwqlm2rZ3UGBj23uJ3oFKCt8OCNwF62s1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792828030;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=fL+a58gqeouvc3xspPK6t4p3ebW6hFwJACi90no5Gpk=;
	b=dafWimxTjE6SS+aS2MPW7AbCpXVhY3mQ6QStpDAf1Ab0+cXRaH79svI5lBZIJYV8YP1O
	 1vM6iRbocv2CtjJCyrZpkTW3SwMVQelHueFt+ZqcijBrGFclf25mImj7D2Hk55sGAQWAC
	 P19kpTZP04fGtXgLDFu73oivazzkf1cB1PwkA8UNUqoZu0+PxTgPf7jYBa5WWUvq5oBz8
	 JVym+/vyzPfjutC2G8hq8Z3kE2THvM3blI7Bb5Z8FuDV9xieMNRA8Dn2O2NODpoKC7Fb3
	 nISo2CJdCDcyYZMNCakgYjbcti9PnKKayEj9evZOHW5mm1kAPTvTEywkFTq42L548BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XTQLUmks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFC6606A31A;
	Sat, 24 Oct 2026 07:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XTQLUmks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BBE1F01825;
	Sat, 24 Oct 2026 07:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792828029;
	bh=fL+a58gqeouvc3xspPK6t4p3ebW6hFwJACi90no5Gpk=;
	h=Date:To:From:Subject;
	b=XTQLUmksdepERDKTcdN/7MnH9pHE3LVYlOiUJe83r4UpD/S+DVV24aM2l8PhqYboX
	 qoCipMs5Uw0vNm4RW3uL45S+BDa5vTIOAQuilmNJ4tyOicGDeKzq0ighOVwSw+TUW+
	 4uhsckpbfmYQcDvDlF9zSXb/bst1Sc/05SOMfPKk=
Date: Sat, 24 Oct 2026 00:47:08 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,stable@vger.kernel.org,arnd@arndb.de,akpm@linux-foundation.org,dennylin0707@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] compat-avoid-double-rounding-in-times.patch removed from -mm tree
Message-Id: <20261024074709.36BBE1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: compat: avoid double rounding in times()
has been removed from the -mm tree.  Its filename was
     compat-avoid-double-rounding-in-times.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hungyu Lin <dennylin0707@gmail.com>
Subject: compat: avoid double rounding in times()
Date: Tue, 20 Oct 2026 21:01:57 +0000

do_sys_times() already converts CPU time to USER_HZ ticks.  The compat
path converts each value back to jiffies before converting it to
COMPAT_USER_HZ.  This round trip can lose precision even when the two
userspace rates match.

With HZ=250 and USER_HZ=COMPAT_USER_HZ=100, one user tick becomes two
jiffies and then zero compat ticks.  Every odd tick count loses one tick,
so any of the four tms fields can underreport CPU time by an additional 10
ms.

Return the value directly when the native and compat units match.  Keep
the existing conversion for differing rates.

Link: https://lore.kernel.org/20261020210157.52057-1-dennylin0707@gmail.com
Fixes: f06febc96ba8 ("timers: fix itimer/many thread hang")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: <stable@vger.kernel.org>
---

 kernel/sys.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/sys.c~compat-avoid-double-rounding-in-times
+++ a/kernel/sys.c
@@ -1077,6 +1077,9 @@ SYSCALL_DEFINE1(times, struct tms __user
 #ifdef CONFIG_COMPAT
 static compat_clock_t clock_t_to_compat_clock_t(clock_t x)
 {
+	if (USER_HZ == COMPAT_USER_HZ)
+		return x;
+
 	return compat_jiffies_to_clock_t(clock_t_to_jiffies(x));
 }
 
_

Patches currently in -mm which might be from dennylin0707@gmail.com are

mm-page-writeback-avoid-32-bit-overflow-in-dirty-threshold-shares.patch

