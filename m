Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795337410;
	b=kuwYblV1i8XTU+LgG9qV9IAWq2gIZEAcnruU2iRfmtY7SPvNyBLbvpaLdnBDCtMmR8cZ
	 NncJkT9/daDOBBmqNjfjc2bVYl59tRKISA6ISyWZdyzZAF5dVXSwTA/IZSNLOd+xGdi4/
	 MOgrm0xm91oUilCT84dPufrJHZ+FMY0g53CF3zLkVPRkTqiPqOSf4RKugigisq4MPvunI
	 RuXeYgMi55SBwqTmpzmtHG4+mjXn7+8n3ikn/bdGYbDUP/u1Xiq4Y1PxzGZki6jeSo7Fg
	 ZulZmLvHrJ3yZxkpFXwrEn5V7Rm7TWidSyxFu6dkxJFvObBjtuOpHv1S9jVMWkPSe1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795337410;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=p8tfuaVrgp9uEEnQd3pgxOAVPImKUh+U/5HZnngQu4k=;
	b=eETjndWMjoDI9ASNA54dPLMkvdUuEvAi/POs06HMvprZHB5lEQK2q3FTrLhjbxMx5QX2
	 CjKj8PgenvpUhE6AqTH2pTP5xWHTy+YSG4yNcLJYZN+lD3q/pSrR0XB4aNx1yatPmKXOm
	 l0BXpbTwo37OUI4yNiXQVklQlcKLWEsEEYdrY/BTOylSM1NJmrx47en5Wi68SHSZxsQnh
	 Ofe92yvN6VcxoYj8kIesQyHWmn4qfD3kRyhglfElB8fiwsqsmW6DPJ0u8vQAHyBPP8gg3
	 nEPfA6TScdgMwziLDBP5K3wxR6Sk3L1VjlEWOQsNOS7p2ZZdXJpM9pIg++WTEpls4Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ajKXvUkb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E68606A320
	for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 08:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ajKXvUkb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8241F000C0;
	Sun, 22 Nov 2026 08:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795337409;
	bh=p8tfuaVrgp9uEEnQd3pgxOAVPImKUh+U/5HZnngQu4k=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=ajKXvUkb9QzDoPBMepcK0MJA0YSlaEqN/65gjsLjzTUBvufCy8O4nFmSVlao4cvti
	 7R51ehwv2apAshj7cQK3SOkFhINzi9bzcarAwkpD7q6YHSB1b0kkRIzh7JR7FR4hZY
	 oXp2vZeAvWyBidcGZDmFI/qnE8pWe2Qe9hXju92k=
Date: Sun, 22 Nov 2026 00:50:08 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,bfaccini@nvidia.com,
	ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261114132625.1710476-1-ekffu200098@gmail.com>
References: <20261114132625.1710476-1-ekffu200098@gmail.com>
Subject: + arch_numa-fix-broken-numa-emulation-with-dummy_numa_init.patch added to mm-unstable branch
Message-Id: <20261122085009.7A8241F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: arch_numa: fix broken NUMA emulation with dummy_numa_init()
has been added to the -mm mm-unstable branch.  Its filename is
     arch_numa-fix-broken-numa-emulation-with-dummy_numa_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch_numa-fix-broken-numa-emulation-with-dummy_numa_init.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: arch_numa: fix broken NUMA emulation with dummy_numa_init()
Date: Sat, 14 Nov 2026 22:26:24 +0900

If arch_numa_init() falls back to dummy_numa_init(), numa_off is set to
true before numa_emulation() runs.  Then numa_emulation() calls
fix_pxm_node_maps(), which fails when CONFIG_ACPI_NUMA is enabled and
numa_off is true, so numa=fake is ignored in that case.

So set numa_off in arch_numa_init() after numa_emulation() runs
instead.

Link: https://patch.msgid.link/20261114132625.1710476-1-ekffu200098@gmail.com
Fixes: 63db8170bf34 ("mm/fake-numa: allow later numa node hotplug")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Bruno Faccini <bfaccini@nvidia.com>

 mm/arch_numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/arch_numa.c~arch_numa-fix-broken-numa-emulation-with-dummy_numa_init
+++ a/mm/arch_numa.c
@@ -289,7 +289,6 @@ static int __init dummy_numa_init(void)
 		return ret;
 	}
 
-	numa_off = true;
 	return 0;
 }
 
@@ -329,6 +328,7 @@ void __init arch_numa_init(void)
 	}
 
 	numa_init(dummy_numa_init);
+	numa_off = true;
 }
 
 #ifdef CONFIG_NUMA_EMU
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

arch_numa-fix-broken-numa-emulation-with-dummy_numa_init.patch
fault-inject-use-a-shared-initialization-helper-for-the-random-state.patch
fault-inject-fix-wrong-unit-of-verbose_ratelimit_interval_ms.patch
fault-injection-fix-typo-in-failcmdsh.patch

