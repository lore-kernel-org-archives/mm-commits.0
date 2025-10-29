Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2903191D0;
	Wed, 29 Oct 2025 22:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761775714; cv=none; b=VEFWNxIwu2xdhbpYM7tSmiSorvqV6fsTJCVmRFwi2y2GtDBFvbYUkNOnOdkqCqsk2Eg7Z9MP+BRoSPpp6I9kHAhaOfDOSYKwerYccI+WLRV/VI2tmzhCqYmb21FrCYwCwBN+WJdtXsxklORpIdEExs+ujJwcJw/zEVfQV3IYJZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761775714; c=relaxed/simple;
	bh=V5r0AuGHxPwadS3uNhY/7bjXTpHeRT2W4BWkg+wpGoY=;
	h=Date:To:From:Subject:Message-Id; b=IMJoVM/Cm5DuRoS+1gqKPEG4GWms/d7Ibi32O90gVcQ34VO3b6RqvGkqqg6d6xpO87sU12g/eKYoQ2gAlgMuCLycZKQ7TUzG+fXCVFnsRIQy0RSzcbk3t35kdHnB6ln6BpM0qPCB66glVIBwZqzAdsrdPuxnzsq0WWmhrXYy+rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KSc0y2Wq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KSc0y2Wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B26C4CEF7;
	Wed, 29 Oct 2025 22:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761775714;
	bh=V5r0AuGHxPwadS3uNhY/7bjXTpHeRT2W4BWkg+wpGoY=;
	h=Date:To:From:Subject:From;
	b=KSc0y2Wqz7FGCz0Zd8h4RnTEIcHL5V9UfV5NXNzQPrl3wxhlUfx3G9C5VP0wwet9a
	 /0sQ9Xu8afMuPe6PWz4MbueaBUqYHvoS9T1v3ZwYY+NxhqMR9io/aCq5g91zF2ebku
	 8xMdsFLlTTNqbT26//427biMqm/OfyvgTBJs8DPo=
Date: Wed, 29 Oct 2025 15:08:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yeoreum.yun@arm.com,xin@zytor.com,will@kernel.org,wangkefeng.wang@huawei.com,vincenzo.frascino@arm.com,vbabka@suse.cz,urezki@gmail.com,ubizjak@gmail.com,trintaeoitogc@gmail.com,thuth@redhat.com,tglx@linutronix.de,surenb@google.com,stable@vger.kernel.org,smostafa@google.com,samuel.holland@sifive.com,ryabinin.a.a@gmail.com,rppt@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,pankaj.gupta@amd.com,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mingo@redhat.com,mhocko@suse.com,maz@kernel.org,mark.rutland@arm.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leitao@debian.org,kees@kernel.org,kbingham@kernel.org,kaleshsingh@google.com,justinstitt@google.com,jpoimboe@kernel.org,jhubbard@nvidia.com,jeremy.linton@arm.com,jan.kiszka@siemens.com,hpa@zytor.com,glider@google.com,fujita.tomonori@gmail.com,elver@google.com,dvyukov@google.com,david@redhat.com,corbet@lwn.net,catalin.marinas@arm.com,broonie@kernel.org,brgerst@gmail.com,bp@alien8.de,bigeasy@linutronix.de,bhe@redhat.com,baohua@kernel.org,ardb@kernel.org,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-unpoison-vms-addresses-with-a-common-tag.patch added to mm-hotfixes-unstable branch
Message-Id: <20251029220833.E2B26C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: unpoison vms[area] addresses with a common tag
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-unpoison-vms-addresses-with-a-common-tag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-unpoison-vms-addresses-with-a-common-tag.patch

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
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Subject: kasan: unpoison vms[area] addresses with a common tag
Date: Wed, 29 Oct 2025 19:06:03 +0000

The problem presented here is related to NUMA systems and tag-based KASAN
modes - software and hardware ones.  It can be explained in the following
points:

1. There can be more than one virtual memory chunk.

2. Chunk's base address has a tag.

3. The base address points at the first chunk and thus inherits the
   tag of the first chunk.

4. The subsequent chunks will be accessed with the tag from the first
   chunk.

5. Thus, the subsequent chunks need to have their tag set to match
   that of the first chunk.

Unpoison all vms[]->addr memory and pointers with the same tag to resolve
the mismatch.

Link: https://lkml.kernel.org/r/932121edc75be8e2038d64ecb4853df2e2b258df.1761763681.git.m.wieczorretman@pm.me
Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Tested-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Breno Leitao <leitao@debian.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jeremy Linton <jeremy.linton@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: levi.yun <yeoreum.yun@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Marco Elver <elver@google.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mostafa Saleh <smostafa@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Huth <thuth@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Xin Li (Intel) <xin@zytor.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>	[6.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/tags.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/kasan/tags.c~kasan-unpoison-vms-addresses-with-a-common-tag
+++ a/mm/kasan/tags.c
@@ -148,12 +148,20 @@ void __kasan_save_free_info(struct kmem_
 	save_stack_info(cache, object, 0, true);
 }
 
+/*
+ * A tag mismatch happens when calculating per-cpu chunk addresses, because
+ * they all inherit the tag from vms[0]->addr, even when nr_vms is bigger
+ * than 1. This is a problem because all the vms[]->addr come from separate
+ * allocations and have different tags so while the calculated address is
+ * correct the tag isn't.
+ */
 void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
 {
 	int area;
 
 	for (area = 0 ; area < nr_vms ; area++) {
 		kasan_poison(vms[area]->addr, vms[area]->size,
-			     arch_kasan_get_tag(vms[area]->addr), false);
+			     arch_kasan_get_tag(vms[0]->addr), false);
+		arch_kasan_set_tag(vms[area]->addr, arch_kasan_get_tag(vms[0]->addr));
 	}
 }
_

Patches currently in -mm which might be from maciej.wieczor-retman@intel.com are

kasan-unpoison-pcpu-chunks-with-base-address-tag.patch
kasan-unpoison-vms-addresses-with-a-common-tag.patch

