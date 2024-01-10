Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A1A53A6
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 04:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p026VZw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBA9C433C7;
	Wed, 10 Jan 2024 04:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704860170;
	bh=piw1etwgnnkxZVnWotknzr/xvOt/wLXZFvyDz0GXN3c=;
	h=Date:To:From:Subject:From;
	b=p026VZw6pF6k/ipGGciz7HvA2zH3DnJdUCciZWMZhgirf9GGTjuEYHU0RG/4ieLV0
	 bGPK94HqAQQtzoW76XuOQpzSgalYa6YBXAyYC8lcLdSgYtixROflhZ6BJncIvHrWfk
	 f5WnGWHgDw9ExlSxtCOWZ4xj1yC6UWh3n7svqHkY=
Date: Tue, 09 Jan 2024 20:16:10 -0800
To: mm-commits@vger.kernel.org,mykolal@fb.com,daniel@iogearbox.net,ast@kernel.org,andrii@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-bpf-update-llvm-phabricator-links.patch added to mm-nonmm-unstable branch
Message-Id: <20240110041610.8DBA9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/bpf: update LLVM Phabricator links
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-bpf-update-llvm-phabricator-links.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-bpf-update-llvm-phabricator-links.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Nathan Chancellor <nathan@kernel.org>
Subject: selftests/bpf: update LLVM Phabricator links
Date: Tue, 09 Jan 2024 15:16:29 -0700

Patch series "Update LLVM Phabricator and Bugzilla links".

This series updates all instances of LLVM Phabricator and Bugzilla links
to point to GitHub commits directly and LLVM's Bugzilla to GitHub issue
shortlinks respectively.

I split up the Phabricator patch into BPF selftests and the rest of the
kernel in case the BPF folks want to take it separately from the rest of
the series, there are obviously no dependency issues in that case.  The
Bugzilla change was mechanical enough and should have no conflicts.


This patch (of 3):

reviews.llvm.org was LLVM's Phabricator instances for code review.  It has
been abandoned in favor of GitHub pull requests.  While the majority of
links in the kernel sources still work because of the work Fangrui has
done turning the dynamic Phabricator instance into a static archive, there
are some issues with that work, so preemptively convert all the links in
the kernel sources to point to the commit on GitHub.

Most of the commits have the corresponding differential review link in the
commit message itself so there should not be any loss of fidelity in the
relevant information.

Additionally, fix a typo in the xdpwall.c print ("LLMV" -> "LLVM") while
in the area.

Link: https://lkml.kernel.org/r/20240109-update-llvm-links-v1-0-eb09b59db071@kernel.org
Link: https://discourse.llvm.org/t/update-on-github-pull-requests/71540/172
Link: https://lkml.kernel.org/r/20240109-update-llvm-links-v1-1-eb09b59db071@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Mykola Lysenko <mykolal@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/bpf/README.rst                      |   32 +++++-----
 tools/testing/selftests/bpf/prog_tests/xdpwall.c            |    2 
 tools/testing/selftests/bpf/progs/test_core_reloc_type_id.c |    2 
 3 files changed, 18 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/bpf/progs/test_core_reloc_type_id.c~selftests-bpf-update-llvm-phabricator-links
+++ a/tools/testing/selftests/bpf/progs/test_core_reloc_type_id.c
@@ -80,7 +80,7 @@ int test_core_type_id(void *ctx)
 	 * to detect whether this test has to be executed, however strange
 	 * that might look like.
 	 *
-	 *   [0] https://reviews.llvm.org/D85174
+	 *   [0] https://github.com/llvm/llvm-project/commit/00602ee7ef0bf6c68d690a2bd729c12b95c95c99
 	 */
 #if __has_builtin(__builtin_preserve_type_info)
 	struct core_reloc_type_id_output *out = (void *)&data.out;
--- a/tools/testing/selftests/bpf/prog_tests/xdpwall.c~selftests-bpf-update-llvm-phabricator-links
+++ a/tools/testing/selftests/bpf/prog_tests/xdpwall.c
@@ -9,7 +9,7 @@ void test_xdpwall(void)
 	struct xdpwall *skel;
 
 	skel = xdpwall__open_and_load();
-	ASSERT_OK_PTR(skel, "Does LLMV have https://reviews.llvm.org/D109073?");
+	ASSERT_OK_PTR(skel, "Does LLVM have https://github.com/llvm/llvm-project/commit/ea72b0319d7b0f0c2fcf41d121afa5d031b319d5?");
 
 	xdpwall__destroy(skel);
 }
--- a/tools/testing/selftests/bpf/README.rst~selftests-bpf-update-llvm-phabricator-links
+++ a/tools/testing/selftests/bpf/README.rst
@@ -115,7 +115,7 @@ the insn 20 undoes map_value addition. I
 verifier to understand such speculative pointer arithmetic.
 Hence `this patch`__ addresses it on the compiler side. It was committed on llvm 12.
 
-__ https://reviews.llvm.org/D85570
+__ https://github.com/llvm/llvm-project/commit/ddf1864ace484035e3cde5e83b3a31ac81e059c6
 
 The corresponding C code
 
@@ -165,7 +165,7 @@ This is due to a llvm BPF backend bug. `
 has been pushed to llvm 10.x release branch and will be
 available in 10.0.1. The patch is available in llvm 11.0.0 trunk.
 
-__  https://reviews.llvm.org/D78466
+__  https://github.com/llvm/llvm-project/commit/3cb7e7bf959dcd3b8080986c62e10a75c7af43f0
 
 bpf_verif_scale/loop6.bpf.o test failure with Clang 12
 ======================================================
@@ -204,7 +204,7 @@ r5(w5) is eventually saved on stack at i
 This cause later verifier failure. The bug has been `fixed`__ in
 Clang 13.
 
-__  https://reviews.llvm.org/D97479
+__  https://github.com/llvm/llvm-project/commit/1959ead525b8830cc8a345f45e1c3ef9902d3229
 
 BPF CO-RE-based tests and Clang version
 =======================================
@@ -221,11 +221,11 @@ failures:
 - __builtin_btf_type_id() [0_, 1_, 2_];
 - __builtin_preserve_type_info(), __builtin_preserve_enum_value() [3_, 4_].
 
-.. _0: https://reviews.llvm.org/D74572
-.. _1: https://reviews.llvm.org/D74668
-.. _2: https://reviews.llvm.org/D85174
-.. _3: https://reviews.llvm.org/D83878
-.. _4: https://reviews.llvm.org/D83242
+.. _0: https://github.com/llvm/llvm-project/commit/6b01b465388b204d543da3cf49efd6080db094a9
+.. _1: https://github.com/llvm/llvm-project/commit/072cde03aaa13a2c57acf62d79876bf79aa1919f
+.. _2: https://github.com/llvm/llvm-project/commit/00602ee7ef0bf6c68d690a2bd729c12b95c95c99
+.. _3: https://github.com/llvm/llvm-project/commit/6d218b4adb093ff2e9764febbbc89f429412006c
+.. _4: https://github.com/llvm/llvm-project/commit/6d6750696400e7ce988d66a1a00e1d0cb32815f8
 
 Floating-point tests and Clang version
 ======================================
@@ -234,7 +234,7 @@ Certain selftests, e.g. core_reloc, requ
 types, which was introduced in `Clang 13`__. The older Clang versions will
 either crash when compiling these tests, or generate an incorrect BTF.
 
-__  https://reviews.llvm.org/D83289
+__  https://github.com/llvm/llvm-project/commit/a7137b238a07d9399d3ae96c0b461571bd5aa8b2
 
 Kernel function call test and Clang version
 ===========================================
@@ -248,7 +248,7 @@ Without it, the error from compiling bpf
 
   libbpf: failed to find BTF for extern 'tcp_slow_start' [25] section: -2
 
-__ https://reviews.llvm.org/D93563
+__ https://github.com/llvm/llvm-project/commit/886f9ff53155075bd5f1e994f17b85d1e1b7470c
 
 btf_tag test and Clang version
 ==============================
@@ -264,8 +264,8 @@ Without them, the btf_tag selftest will
 
   #<test_num> btf_tag:SKIP
 
-.. _0: https://reviews.llvm.org/D111588
-.. _1: https://reviews.llvm.org/D111199
+.. _0: https://github.com/llvm/llvm-project/commit/a162b67c98066218d0d00aa13b99afb95d9bb5e6
+.. _1: https://github.com/llvm/llvm-project/commit/3466e00716e12e32fdb100e3fcfca5c2b3e8d784
 
 Clang dependencies for static linking tests
 ===========================================
@@ -274,7 +274,7 @@ linked_vars, linked_maps, and linked_fun
 generate valid BTF information for weak variables. Please make sure you use
 Clang that contains the fix.
 
-__ https://reviews.llvm.org/D100362
+__ https://github.com/llvm/llvm-project/commit/968292cb93198442138128d850fd54dc7edc0035
 
 Clang relocation changes
 ========================
@@ -292,7 +292,7 @@ Here, ``type 2`` refers to new relocatio
 To fix this issue, user newer libbpf.
 
 .. Links
-.. _clang reloc patch: https://reviews.llvm.org/D102712
+.. _clang reloc patch: https://github.com/llvm/llvm-project/commit/6a2ea84600ba4bd3b2733bd8f08f5115eb32164b
 .. _kernel llvm reloc: /Documentation/bpf/llvm_reloc.rst
 
 Clang dependencies for the u32 spill test (xdpwall)
@@ -304,6 +304,6 @@ from running test_progs will look like:
 
 .. code-block:: console
 
-  test_xdpwall:FAIL:Does LLVM have https://reviews.llvm.org/D109073? unexpected error: -4007
+  test_xdpwall:FAIL:Does LLVM have https://github.com/llvm/llvm-project/commit/ea72b0319d7b0f0c2fcf41d121afa5d031b319d5? unexpected error: -4007
 
-__ https://reviews.llvm.org/D109073
+__ https://github.com/llvm/llvm-project/commit/ea72b0319d7b0f0c2fcf41d121afa5d031b319d
_

Patches currently in -mm which might be from nathan@kernel.org are

lib-kconfigdebug-disable-config_debug_info_btf-for-hexagon.patch
selftests-bpf-update-llvm-phabricator-links.patch
arch-and-include-update-llvm-phabricator-links.patch
treewide-update-llvm-bugzilla-links.patch

