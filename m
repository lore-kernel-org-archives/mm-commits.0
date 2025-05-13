Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7A71D6DB4
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119268; cv=none; b=mnD1jI0O+lkmD5lOBVzZx9HMcS+CpzXxUiV0fLrzKQimY2kQaZw/m7eqM3Zndr3tAT0FpEpt46YutIehRB1Lnew7LxEhIya/xhrw6J2BwqVUrDOj6N29pEHcTm2vGRvWFNR4UNL0aSLjuG2I+TtTH3GyG26DwWM0CFkoMyKXyDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119268; c=relaxed/simple;
	bh=RHUOwpuNupijltNyPehHmqKz7D0vEtgjflkkztQIf9I=;
	h=Date:To:From:Subject:Message-Id; b=EPPRA1InE35/EfkK8ZKERodAhRGyv3A95VwtgYF2S9gZr9vrYESJI6BFi7R35tWWSprW94Fh0+9naFABkRZTA6XE/66aE/Re8TidIysi3/bhb7KE2kk4l+V6kEaUIes9+dYe+5nrRGJSrbYmsO88XzKzKiBpjFHzv/OeFDHbX9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ifNyz2Ub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ifNyz2Ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4BCC4CEE4;
	Tue, 13 May 2025 06:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119267;
	bh=RHUOwpuNupijltNyPehHmqKz7D0vEtgjflkkztQIf9I=;
	h=Date:To:From:Subject:From;
	b=ifNyz2UbcPNvfi2Tqwn0A53wfoH3ORNQfC4cOWS2cQqoPDrbE7cJ4OnxWnLoLJYOM
	 2a1T2cz0TsWdVoWjIoeJ/gfo3KcCEWTSDneguVc/ajUgKtNNUe7WUbss83faAWo3Qy
	 FBUA1MS8bZ9Zrvlllnfdts2Pnh+oydqBoI/CPm8c=
Date: Mon, 12 May 2025 23:54:27 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rppt@kernel.org,rostedt@goodmis.org,robh@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,jgg@nvidia.com,hpa@zytor.com,ebiederm@xmission.com,dwmw2@infradead.org,dave.hansen@linux.intel.com,corbet@lwn.net,changyuanl@google.com,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-e820-temporarily-enable-kho-scratch-for-memory-below-1m.patch removed from -mm tree
Message-Id: <20250513065427.BF4BCC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/e820: temporarily enable KHO scratch for memory below 1M
has been removed from the -mm tree.  Its filename was
     x86-e820-temporarily-enable-kho-scratch-for-memory-below-1m.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Graf <graf@amazon.com>
Subject: x86/e820: temporarily enable KHO scratch for memory below 1M
Date: Fri, 9 May 2025 00:46:30 -0700

KHO kernels are special and use only scratch memory for memblock
allocations, but memory below 1M is ignored by kernel after early boot and
cannot be naturally marked as scratch.

To allow allocation of the real-mode trampoline and a few (if any) other
very early allocations from below 1M forcibly mark the memory below 1M as
scratch.

After real mode trampoline is allocated, clear that scratch marking.

Link: https://lkml.kernel.org/r/20250509074635.3187114-13-changyuanl@google.com
Signed-off-by: Alexander Graf <graf@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Co-developed-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Gowans <jgowans@amazon.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820.c   |   18 ++++++++++++++++++
 arch/x86/realmode/init.c |    2 ++
 2 files changed, 20 insertions(+)

--- a/arch/x86/kernel/e820.c~x86-e820-temporarily-enable-kho-scratch-for-memory-below-1m
+++ a/arch/x86/kernel/e820.c
@@ -1300,6 +1300,24 @@ void __init e820__memblock_setup(void)
 	}
 
 	/*
+	 * At this point memblock is only allowed to allocate from memory
+	 * below 1M (aka ISA_END_ADDRESS) up until direct map is completely set
+	 * up in init_mem_mapping().
+	 *
+	 * KHO kernels are special and use only scratch memory for memblock
+	 * allocations, but memory below 1M is ignored by kernel after early
+	 * boot and cannot be naturally marked as scratch.
+	 *
+	 * To allow allocation of the real-mode trampoline and a few (if any)
+	 * other very early allocations from below 1M forcibly mark the memory
+	 * below 1M as scratch.
+	 *
+	 * After real mode trampoline is allocated, we clear that scratch
+	 * marking.
+	 */
+	memblock_mark_kho_scratch(0, SZ_1M);
+
+	/*
 	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
 	 * to even less without it.
 	 * Discard memory after max_pfn - the actual limit detected at runtime.
--- a/arch/x86/realmode/init.c~x86-e820-temporarily-enable-kho-scratch-for-memory-below-1m
+++ a/arch/x86/realmode/init.c
@@ -65,6 +65,8 @@ void __init reserve_real_mode(void)
 	 * setup_arch().
 	 */
 	memblock_reserve(0, SZ_1M);
+
+	memblock_clear_kho_scratch(0, SZ_1M);
 }
 
 static void __init sme_sev_setup_real_mode(struct trampoline_header *th)
_

Patches currently in -mm which might be from graf@amazon.com are


