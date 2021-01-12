Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2ECC433DB
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 04:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 507F22250E
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 04:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731170AbhALEoe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Jan 2021 23:44:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbhALEoe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 Jan 2021 23:44:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 233F8222F9;
        Tue, 12 Jan 2021 04:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610426632;
        bh=vudOfmRBIKt43hTEKLujqlfVWvMnt7HWRTyKdABMBuU=;
        h=Date:From:To:Subject:From;
        b=dLrfP2PohuE2mI0hHFyoHm4BQAh6LhgFMO6rgzPQ/7of/EpqkZWhns76cSE5iXY47
         nr5dil+ybkJH3G41feQGH7OGdaURFuk9I5qj5f8NZy0xsTL/1OxdbXAPQkgEm8Ixg3
         8SOf0DO46IeFNY5Stvr504BOFZCRe8BUCiBeZIbA=
Date:   Mon, 11 Jan 2021 20:43:51 -0800
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, joern@purestorage.com, mm-commits@vger.kernel.org
Subject:  + kfence-add-test-suite-fix-2.patch added to -mm tree
Message-ID: <20210112044351.W3ghxZCzQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: show access type in report
has been added to the -mm tree.  Its filename is
     kfence-add-test-suite-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-add-test-suite-fix-2.p=
atch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-add-test-suite-fix-2.p=
atch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Marco Elver <elver@google.com>
Subject: kfence: show access type in report

Show the access type in KFENCE reports by plumbing through read/write
information from the page fault handler.  Update the documentation and
test accordingly.

Link: https://lkml.kernel.org/r/20210111091544.3287013-2-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Suggested-by: J=C3=B6rn Engel <joern@purestorage.com>
Reviewed-by: J=C3=B6rn Engel <joern@purestorage.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kfence.rst |   12 +++---
 arch/arm64/mm/fault.c              |    2 -
 arch/x86/mm/fault.c                |    3 +
 include/linux/kfence.h             |    9 ++++-
 mm/kfence/core.c                   |   11 +++---
 mm/kfence/kfence.h                 |    2 -
 mm/kfence/kfence_test.c            |   47 +++++++++++++++++++++++----
 mm/kfence/report.c                 |   27 ++++++++++-----
 8 files changed, 82 insertions(+), 31 deletions(-)

--- a/arch/arm64/mm/fault.c~kfence-add-test-suite-fix-2
+++ a/arch/arm64/mm/fault.c
@@ -386,7 +386,7 @@ static void __do_kernel_fault(unsigned l
 	} else if (addr < PAGE_SIZE) {
 		msg =3D "NULL pointer dereference";
 	} else {
-		if (kfence_handle_page_fault(addr, regs))
+		if (kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
 			return;
=20
 		msg =3D "paging request";
--- a/arch/x86/mm/fault.c~kfence-add-test-suite-fix-2
+++ a/arch/x86/mm/fault.c
@@ -734,7 +734,8 @@ no_context(struct pt_regs *regs, unsigne
 		efi_recover_from_page_fault(address);
=20
 	/* Only not-present faults should be handled by KFENCE. */
-	if (!(error_code & X86_PF_PROT) && kfence_handle_page_fault(address, regs=
))
+	if (!(error_code & X86_PF_PROT) &&
+	    kfence_handle_page_fault(address, error_code & X86_PF_WRITE, regs))
 		return;
=20
 oops:
--- a/Documentation/dev-tools/kfence.rst~kfence-add-test-suite-fix-2
+++ a/Documentation/dev-tools/kfence.rst
@@ -64,9 +64,9 @@ Error reports
 A typical out-of-bounds access looks like this::
=20
     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
-    BUG: KFENCE: out-of-bounds in test_out_of_bounds_read+0xa3/0x22b
+    BUG: KFENCE: out-of-bounds read in test_out_of_bounds_read+0xa3/0x22b
=20
-    Out-of-bounds access at 0xffffffffb672efff (1B left of kfence-#17):
+    Out-of-bounds read at 0xffffffffb672efff (1B left of kfence-#17):
      test_out_of_bounds_read+0xa3/0x22b
      kunit_try_run_case+0x51/0x85
      kunit_generic_run_threadfn_adapter+0x16/0x30
@@ -93,9 +93,9 @@ its origin. Note that, real kernel addre
 Use-after-free accesses are reported as::
=20
     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
-    BUG: KFENCE: use-after-free in test_use_after_free_read+0xb3/0x143
+    BUG: KFENCE: use-after-free read in test_use_after_free_read+0xb3/0x143
=20
-    Use-after-free access at 0xffffffffb673dfe0 (in kfence-#24):
+    Use-after-free read at 0xffffffffb673dfe0 (in kfence-#24):
      test_use_after_free_read+0xb3/0x143
      kunit_try_run_case+0x51/0x85
      kunit_generic_run_threadfn_adapter+0x16/0x30
@@ -192,9 +192,9 @@ where it was not possible to determine a
 object pages had not yet been allocated::
=20
     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
-    BUG: KFENCE: invalid access in test_invalid_access+0x26/0xe0
+    BUG: KFENCE: invalid read in test_invalid_access+0x26/0xe0
=20
-    Invalid access at 0xffffffffb670b00a:
+    Invalid read at 0xffffffffb670b00a:
      test_invalid_access+0x26/0xe0
      kunit_try_run_case+0x51/0x85
      kunit_generic_run_threadfn_adapter+0x16/0x30
--- a/include/linux/kfence.h~kfence-add-test-suite-fix-2
+++ a/include/linux/kfence.h
@@ -180,6 +180,7 @@ static __always_inline __must_check bool
 /**
  * kfence_handle_page_fault() - perform page fault handling for KFENCE pag=
es
  * @addr: faulting address
+ * @is_write: is access a write
  * @regs: current struct pt_regs (can be NULL, but shows full stack trace)
  *
  * Return:
@@ -191,7 +192,7 @@ static __always_inline __must_check bool
  * cases KFENCE prints an error message and marks the offending page as
  * present, so that the kernel can proceed.
  */
-bool __must_check kfence_handle_page_fault(unsigned long addr, struct pt_r=
egs *regs);
+bool __must_check kfence_handle_page_fault(unsigned long addr, bool is_wri=
te, struct pt_regs *regs);
=20
 #else /* CONFIG_KFENCE */
=20
@@ -204,7 +205,11 @@ static inline size_t kfence_ksize(const
 static inline void *kfence_object_start(const void *addr) { return NULL; }
 static inline void __kfence_free(void *addr) { }
 static inline bool __must_check kfence_free(void *addr) { return false; }
-static inline bool __must_check kfence_handle_page_fault(unsigned long add=
r, struct pt_regs *regs) { return false; }
+static inline bool __must_check kfence_handle_page_fault(unsigned long add=
r, bool is_write,
+							 struct pt_regs *regs)
+{
+	return false;
+}
=20
 #endif
=20
--- a/mm/kfence/core.c~kfence-add-test-suite-fix-2
+++ a/mm/kfence/core.c
@@ -211,7 +211,7 @@ static inline bool check_canary_byte(u8
 		return true;
=20
 	atomic_long_inc(&counters[KFENCE_COUNTER_BUGS]);
-	kfence_report_error((unsigned long)addr, NULL, addr_to_metadata((unsigned=
 long)addr),
+	kfence_report_error((unsigned long)addr, false, NULL, addr_to_metadata((u=
nsigned long)addr),
 			    KFENCE_ERROR_CORRUPTION);
 	return false;
 }
@@ -350,7 +350,8 @@ static void kfence_guarded_free(void *ad
 	if (meta->state !=3D KFENCE_OBJECT_ALLOCATED || meta->addr !=3D (unsigned=
 long)addr) {
 		/* Invalid or double-free, bail out. */
 		atomic_long_inc(&counters[KFENCE_COUNTER_BUGS]);
-		kfence_report_error((unsigned long)addr, NULL, meta, KFENCE_ERROR_INVALI=
D_FREE);
+		kfence_report_error((unsigned long)addr, false, NULL, meta,
+				    KFENCE_ERROR_INVALID_FREE);
 		raw_spin_unlock_irqrestore(&meta->lock, flags);
 		return;
 	}
@@ -765,7 +766,7 @@ void __kfence_free(void *addr)
 		kfence_guarded_free(addr, meta, false);
 }
=20
-bool kfence_handle_page_fault(unsigned long addr, struct pt_regs *regs)
+bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt=
_regs *regs)
 {
 	const int page_index =3D (addr - (unsigned long)__kfence_pool) / PAGE_SIZ=
E;
 	struct kfence_metadata *to_report =3D NULL;
@@ -828,11 +829,11 @@ bool kfence_handle_page_fault(unsigned l
=20
 out:
 	if (to_report) {
-		kfence_report_error(addr, regs, to_report, error_type);
+		kfence_report_error(addr, is_write, regs, to_report, error_type);
 		raw_spin_unlock_irqrestore(&to_report->lock, flags);
 	} else {
 		/* This may be a UAF or OOB access, but we can't be sure. */
-		kfence_report_error(addr, regs, NULL, KFENCE_ERROR_INVALID);
+		kfence_report_error(addr, is_write, regs, NULL, KFENCE_ERROR_INVALID);
 	}
=20
 	return kfence_unprotect(addr); /* Unprotect and let access proceed. */
--- a/mm/kfence/kfence.h~kfence-add-test-suite-fix-2
+++ a/mm/kfence/kfence.h
@@ -99,7 +99,7 @@ enum kfence_error_type {
 	KFENCE_ERROR_INVALID_FREE,	/* Invalid free. */
 };
=20
-void kfence_report_error(unsigned long address, struct pt_regs *regs,
+void kfence_report_error(unsigned long address, bool is_write, struct pt_r=
egs *regs,
 			 const struct kfence_metadata *meta, enum kfence_error_type type);
=20
 void kfence_print_object(struct seq_file *seq, const struct kfence_metadat=
a *meta);
--- a/mm/kfence/kfence_test.c~kfence-add-test-suite-fix-2
+++ a/mm/kfence/kfence_test.c
@@ -71,8 +71,14 @@ struct expect_report {
 	enum kfence_error_type type; /* The type or error. */
 	void *fn; /* Function pointer to expected function where access occurred.=
 */
 	char *addr; /* Address at which the bad access occurred. */
+	bool is_write; /* Is access a write. */
 };
=20
+static const char *get_access_type(const struct expect_report *r)
+{
+	return r->is_write ? "write" : "read";
+}
+
 /* Check observed report matches information in @r. */
 static bool report_matches(const struct expect_report *r)
 {
@@ -93,16 +99,19 @@ static bool report_matches(const struct
 	end =3D &expect[0][sizeof(expect[0]) - 1];
 	switch (r->type) {
 	case KFENCE_ERROR_OOB:
-		cur +=3D scnprintf(cur, end - cur, "BUG: KFENCE: out-of-bounds");
+		cur +=3D scnprintf(cur, end - cur, "BUG: KFENCE: out-of-bounds %s",
+				 get_access_type(r));
 		break;
 	case KFENCE_ERROR_UAF:
-		cur +=3D scnprintf(cur, end - cur, "BUG: KFENCE: use-after-free");
+		cur +=3D scnprintf(cur, end - cur, "BUG: KFENCE: use-after-free %s",
+				 get_access_type(r));
 		break;
 	case KFENCE_ERROR_CORRUPTION:
 		cur +=3D scnprintf(cur, end - cur, "BUG: KFENCE: memory corruption");
 		break;
 	case KFENCE_ERROR_INVALID:
-		cur +=3D scnprintf(cur, end - cur, "BUG: KFENCE: invalid access");
+		cur +=3D scnprintf(cur, end - cur, "BUG: KFENCE: invalid %s",
+				 get_access_type(r));
 		break;
 	case KFENCE_ERROR_INVALID_FREE:
 		cur +=3D scnprintf(cur, end - cur, "BUG: KFENCE: invalid free");
@@ -121,16 +130,16 @@ static bool report_matches(const struct
=20
 	switch (r->type) {
 	case KFENCE_ERROR_OOB:
-		cur +=3D scnprintf(cur, end - cur, "Out-of-bounds access at");
+		cur +=3D scnprintf(cur, end - cur, "Out-of-bounds %s at", get_access_typ=
e(r));
 		break;
 	case KFENCE_ERROR_UAF:
-		cur +=3D scnprintf(cur, end - cur, "Use-after-free access at");
+		cur +=3D scnprintf(cur, end - cur, "Use-after-free %s at", get_access_ty=
pe(r));
 		break;
 	case KFENCE_ERROR_CORRUPTION:
 		cur +=3D scnprintf(cur, end - cur, "Corrupted memory at");
 		break;
 	case KFENCE_ERROR_INVALID:
-		cur +=3D scnprintf(cur, end - cur, "Invalid access at");
+		cur +=3D scnprintf(cur, end - cur, "Invalid %s at", get_access_type(r));
 		break;
 	case KFENCE_ERROR_INVALID_FREE:
 		cur +=3D scnprintf(cur, end - cur, "Invalid free of");
@@ -294,6 +303,7 @@ static void test_out_of_bounds_read(stru
 	struct expect_report expect =3D {
 		.type =3D KFENCE_ERROR_OOB,
 		.fn =3D test_out_of_bounds_read,
+		.is_write =3D false,
 	};
 	char *buf;
=20
@@ -321,12 +331,31 @@ static void test_out_of_bounds_read(stru
 	test_free(buf);
 }
=20
+static void test_out_of_bounds_write(struct kunit *test)
+{
+	size_t size =3D 32;
+	struct expect_report expect =3D {
+		.type =3D KFENCE_ERROR_OOB,
+		.fn =3D test_out_of_bounds_write,
+		.is_write =3D true,
+	};
+	char *buf;
+
+	setup_test_cache(test, size, 0, NULL);
+	buf =3D test_alloc(test, size, GFP_KERNEL, ALLOCATE_LEFT);
+	expect.addr =3D buf - 1;
+	WRITE_ONCE(*expect.addr, 42);
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+	test_free(buf);
+}
+
 static void test_use_after_free_read(struct kunit *test)
 {
 	const size_t size =3D 32;
 	struct expect_report expect =3D {
 		.type =3D KFENCE_ERROR_UAF,
 		.fn =3D test_use_after_free_read,
+		.is_write =3D false,
 	};
=20
 	setup_test_cache(test, size, 0, NULL);
@@ -411,6 +440,7 @@ static void test_kmalloc_aligned_oob_rea
 	struct expect_report expect =3D {
 		.type =3D KFENCE_ERROR_OOB,
 		.fn =3D test_kmalloc_aligned_oob_read,
+		.is_write =3D false,
 	};
 	char *buf;
=20
@@ -509,6 +539,7 @@ static void test_init_on_free(struct kun
 	struct expect_report expect =3D {
 		.type =3D KFENCE_ERROR_UAF,
 		.fn =3D test_init_on_free,
+		.is_write =3D false,
 	};
 	int i;
=20
@@ -598,6 +629,7 @@ static void test_invalid_access(struct k
 		.type =3D KFENCE_ERROR_INVALID,
 		.fn =3D test_invalid_access,
 		.addr =3D &__kfence_pool[10],
+		.is_write =3D false,
 	};
=20
 	READ_ONCE(__kfence_pool[10]);
@@ -611,6 +643,7 @@ static void test_memcache_typesafe_by_rc
 	struct expect_report expect =3D {
 		.type =3D KFENCE_ERROR_UAF,
 		.fn =3D test_memcache_typesafe_by_rcu,
+		.is_write =3D false,
 	};
=20
 	setup_test_cache(test, size, SLAB_TYPESAFE_BY_RCU, NULL);
@@ -647,6 +680,7 @@ static void test_krealloc(struct kunit *
 		.type =3D KFENCE_ERROR_UAF,
 		.fn =3D test_krealloc,
 		.addr =3D test_alloc(test, size, GFP_KERNEL, ALLOCATE_ANY),
+		.is_write =3D false,
 	};
 	char *buf =3D expect.addr;
 	int i;
@@ -728,6 +762,7 @@ static void test_memcache_alloc_bulk(str
=20
 static struct kunit_case kfence_test_cases[] =3D {
 	KFENCE_KUNIT_CASE(test_out_of_bounds_read),
+	KFENCE_KUNIT_CASE(test_out_of_bounds_write),
 	KFENCE_KUNIT_CASE(test_use_after_free_read),
 	KFENCE_KUNIT_CASE(test_double_free),
 	KFENCE_KUNIT_CASE(test_invalid_addr_free),
--- a/mm/kfence/report.c~kfence-add-test-suite-fix-2
+++ a/mm/kfence/report.c
@@ -151,7 +151,12 @@ static void print_diff_canary(unsigned l
 	pr_cont(" ]");
 }
=20
-void kfence_report_error(unsigned long address, struct pt_regs *regs,
+static const char *get_access_type(bool is_write)
+{
+	return is_write ? "write" : "read";
+}
+
+void kfence_report_error(unsigned long address, bool is_write, struct pt_r=
egs *regs,
 			 const struct kfence_metadata *meta, enum kfence_error_type type)
 {
 	unsigned long stack_entries[KFENCE_STACK_DEPTH] =3D { 0 };
@@ -189,17 +194,19 @@ void kfence_report_error(unsigned long a
 	case KFENCE_ERROR_OOB: {
 		const bool left_of_object =3D address < meta->addr;
=20
-		pr_err("BUG: KFENCE: out-of-bounds in %pS\n\n", (void *)stack_entries[sk=
ipnr]);
-		pr_err("Out-of-bounds access at 0x" PTR_FMT " (%luB %s of kfence-#%zd):\=
n",
-		       (void *)address,
+		pr_err("BUG: KFENCE: out-of-bounds %s in %pS\n\n", get_access_type(is_wr=
ite),
+		       (void *)stack_entries[skipnr]);
+		pr_err("Out-of-bounds %s at 0x" PTR_FMT " (%luB %s of kfence-#%zd):\n",
+		       get_access_type(is_write), (void *)address,
 		       left_of_object ? meta->addr - address : address - meta->addr,
 		       left_of_object ? "left" : "right", object_index);
 		break;
 	}
 	case KFENCE_ERROR_UAF:
-		pr_err("BUG: KFENCE: use-after-free in %pS\n\n", (void *)stack_entries[s=
kipnr]);
-		pr_err("Use-after-free access at 0x" PTR_FMT " (in kfence-#%zd):\n",
-		       (void *)address, object_index);
+		pr_err("BUG: KFENCE: use-after-free %s in %pS\n\n", get_access_type(is_w=
rite),
+		       (void *)stack_entries[skipnr]);
+		pr_err("Use-after-free %s at 0x" PTR_FMT " (in kfence-#%zd):\n",
+		       get_access_type(is_write), (void *)address, object_index);
 		break;
 	case KFENCE_ERROR_CORRUPTION:
 		pr_err("BUG: KFENCE: memory corruption in %pS\n\n", (void *)stack_entrie=
s[skipnr]);
@@ -208,8 +215,10 @@ void kfence_report_error(unsigned long a
 		pr_cont(" (in kfence-#%zd):\n", object_index);
 		break;
 	case KFENCE_ERROR_INVALID:
-		pr_err("BUG: KFENCE: invalid access in %pS\n\n", (void *)stack_entries[s=
kipnr]);
-		pr_err("Invalid access at 0x" PTR_FMT ":\n", (void *)address);
+		pr_err("BUG: KFENCE: invalid %s in %pS\n\n", get_access_type(is_write),
+		       (void *)stack_entries[skipnr]);
+		pr_err("Invalid %s at 0x" PTR_FMT ":\n", get_access_type(is_write),
+		       (void *)address);
 		break;
 	case KFENCE_ERROR_INVALID_FREE:
 		pr_err("BUG: KFENCE: invalid free in %pS\n\n", (void *)stack_entries[ski=
pnr]);
_

Patches currently in -mm which might be from elver@google.com are

mm-add-kernel-electric-fence-infrastructure-fix.patch
mm-add-kernel-electric-fence-infrastructure-fix-2.patch
mm-add-kernel-electric-fence-infrastructure-fix-3.patch
mm-add-kernel-electric-fence-infrastructure-fix-4.patch
arm64-kfence-enable-kfence-for-arm64.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-add-test-suite.patch
kfence-add-test-suite-fix.patch
kfence-add-test-suite-fix-2.patch
maintainers-add-entry-for-kfence.patch

