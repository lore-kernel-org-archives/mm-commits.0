Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440B63112DB
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967421; cv=none; b=SnxIN+tLrPPOcNpcWfwxpLG1O1x9voIKsDQ5BQgC1Cr6f2JHw5diuf49pbzyZwIMWuZXyYvUvQGkLVZ1igTBZPiga1rC8A4MfwgEspAFfK/rhL5ZeffER3nZZvN0ZY2XNyvJgpVP2WYkrxPv0eMpqEWELk23Sj0C2mDZ38AJG3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967421; c=relaxed/simple;
	bh=GInyFBk/b1egxDvpIqqoh8Age9W3oINPSBUXH2h7V5k=;
	h=Date:To:From:Subject:Message-Id; b=tkTVJr4jY3OcROiEFsXwOEK81M44YZYzibdpsd2VFATkK8F0PrcbT0feF84yh9UJDN8BSTtAKMRrA3EEi6oLO5NIh04kRSKVn7I7la5DtZmSJ74n5O4l6Y8cWvNI505OR0CIa7JuniVo0QD0qdKg5VWDmrgMH5/SvEJxFhVBA8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vDORg/ts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vDORg/ts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68027C2BC87;
	Wed, 21 Jan 2026 03:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967420;
	bh=GInyFBk/b1egxDvpIqqoh8Age9W3oINPSBUXH2h7V5k=;
	h=Date:To:From:Subject:From;
	b=vDORg/tsPL61BpI4PGe2DpR83KIqhr2RVAtPNm41HOZKF8obha86zWK0CKCBmsXZN
	 g0rwt02VVxpnLHizXGiTwo6eKpEK27sKOfaIluLCFHN5G3iZneD/ipKla2c7o1enhX
	 0j9jrCD7UzWRYDoEt3wWHQzjPOVH+ah8Fyg7tE8s=
Date: Tue, 20 Jan 2026 19:50:19 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,will@kernel.org,tglx@linutronix.de,stefan.kristiansson@saunalahti.fi,song@kernel.org,shorne@gmail.com,sdf@fomichev.me,sashal@kernel.org,peterz@infradead.org,mingo@redhat.com,martin.lau@linux.dev,mark.rutland@arm.com,kpsingh@kernel.org,jonas@southpole.se,jolsa@kernel.org,john.fastabend@gmail.com,hpa@zytor.com,haoluo@google.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,gary@garyguo.net,eddyz87@gmail.com,dinguyen@kernel.org,dave.hansen@linux.intel.com,daniel@iogearbox.net,dalias@libc.org,bp@alien8.de,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,ardb@kernel.org,andrii@kernel.org,fthain@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] atomic-add-option-for-weaker-alignment-check.patch removed from -mm tree
Message-Id: <20260121035020.68027C2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: atomic: add option for weaker alignment check
has been removed from the -mm tree.  Its filename was
     atomic-add-option-for-weaker-alignment-check.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Finn Thain <fthain@linux-m68k.org>
Subject: atomic: add option for weaker alignment check
Date: Tue, 13 Jan 2026 16:22:28 +1100

Add a new Kconfig symbol to make CONFIG_DEBUG_ATOMIC more useful on those
architectures which do not align dynamic allocations to 8-byte boundaries.
Without this, CONFIG_DEBUG_ATOMIC produces excessive WARN splats.

Link: https://lkml.kernel.org/r/6d25a12934fe9199332f4d65d17c17de450139a8.1768281748.git.fthain@linux-m68k.org
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Hao Luo <haoluo@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Sasha Levin (Microsoft) <sashal@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/instrumented.h |    8 +++++++-
 lib/Kconfig.debug            |    8 ++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/include/linux/instrumented.h~atomic-add-option-for-weaker-alignment-check
+++ a/include/linux/instrumented.h
@@ -59,7 +59,13 @@ static __always_inline void instrument_r
 static __always_inline void instrument_atomic_check_alignment(const volatile void *v, size_t size)
 {
 #ifndef __DISABLE_EXPORTS
-	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ATOMIC) && ((unsigned long)v & (size - 1)));
+	if (IS_ENABLED(CONFIG_DEBUG_ATOMIC)) {
+		unsigned int mask = size - 1;
+
+		if (IS_ENABLED(CONFIG_DEBUG_ATOMIC_LARGEST_ALIGN))
+			mask &= sizeof(struct { long x; } __aligned_largest) - 1;
+		WARN_ON_ONCE((unsigned long)v & mask);
+	}
 #endif
 }
 
--- a/lib/Kconfig.debug~atomic-add-option-for-weaker-alignment-check
+++ a/lib/Kconfig.debug
@@ -1370,6 +1370,14 @@ config DEBUG_ATOMIC
 
 	  This option has potentially significant overhead.
 
+config DEBUG_ATOMIC_LARGEST_ALIGN
+	bool "Check alignment only up to __aligned_largest"
+	depends on DEBUG_ATOMIC
+	help
+	  If you say Y here then the check for natural alignment of
+	  atomic accesses will be constrained to the compiler's largest
+	  alignment for scalar types.
+
 menu "Lock Debugging (spinlocks, mutexes, etc...)"
 
 config LOCK_DEBUGGING_SUPPORT
_

Patches currently in -mm which might be from fthain@linux-m68k.org are


