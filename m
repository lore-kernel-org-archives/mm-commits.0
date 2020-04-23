From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 kvm-svm-change-flag-passed-to-gup-fast-in-sev_pin_memory.patch added to -mm
 tree
Date: Thu, 23 Apr 2020 15:38:40 -0700
Message-ID: <20200423223840.LLTYNne4w%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgDWWil (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 18:38:41 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@alien8.de, brijesh.singh@amd.com, hpa@zytor.com, hubcap@omnibond.com, ira.weiny@intel.com, Janakarajan.Natarajan@amd.com, jmattson@google.com, joro@8bytes.org, mingo@redhat.com, mm-commits@vger.kernel.org, pbonzini@redhat.com, sean.j.christopherson@intel.com, tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com


The patch titled
     Subject: arch/x86/kvm/svm/sev.c: change flag passed to GUP fast in sev_pin_memory()
has been added to the -mm tree.  Its filename is
     kvm-svm-change-flag-passed-to-gup-fast-in-sev_pin_memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kvm-svm-change-flag-passed-to-gup-fast-in-sev_pin_memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kvm-svm-change-flag-passed-to-gup-fast-in-sev_pin_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Subject: arch/x86/kvm/svm/sev.c: change flag passed to GUP fast in sev_pin_memory()

When trying to lock read-only pages, sev_pin_memory() fails because
FOLL_WRITE is used as the flag for get_user_pages_fast().

Commit 73b0140bf0fe ("mm/gup: change GUP fast to use flags rather than a
write 'bool'") updated the get_user_pages_fast() call sites to use flags,
but incorrectly updated the call in sev_pin_memory().  As the original
coding of this call was correct, revert the change made by that commit.

Link: http://lkml.kernel.org/r/20200423152419.87202-1-Janakarajan.Natarajan@amd.com
Fixes: 73b0140bf0fe ("mm/gup: change GUP fast to use flags rather than a write 'bool'")
Signed-off-by: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/svm/sev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/sev.c~kvm-svm-change-flag-passed-to-gup-fast-in-sev_pin_memory
+++ a/arch/x86/kvm/svm/sev.c
@@ -345,7 +345,7 @@ static struct page **sev_pin_memory(stru
 		return NULL;
 
 	/* Pin the user virtual address. */
-	npinned = get_user_pages_fast(uaddr, npages, FOLL_WRITE, pages);
+	npinned = get_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
 	if (npinned != npages) {
 		pr_err("SEV: Failure locking %lu pages.\n", npages);
 		goto err;
_

Patches currently in -mm which might be from Janakarajan.Natarajan@amd.com are

kvm-svm-change-flag-passed-to-gup-fast-in-sev_pin_memory.patch
