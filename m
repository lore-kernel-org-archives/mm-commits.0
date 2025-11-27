Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CAF31D399
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282430; cv=none; b=om0gCq3KWbozkqont1O1fJ1RlRK8oQbPm/CfRCYq6x+K3RSVFq3a0f/pf7+w5izsA6NwM/qLneVqJr2n7PYex4OU/QfhT7oxZsCg1DF1Ely68UtD3J5p+Kpjly1JhTbqa/rWFEIJWweRIxxH8YDdsdEk1cXZvG7pC6CK+dMCo0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282430; c=relaxed/simple;
	bh=iOFizoi+IaSPsUp7jc4NNyyCoLfoVysCX5RtR8pBDA4=;
	h=Date:To:From:Subject:Message-Id; b=E6ttdaDKZvUIWsQJBnBQR/zUlRr2pyxkRoxIYplPyutG0yfF6gtR19W5c1mcqQp6qN1NLLqWkiZXxbg8KYjwBcn+GBnWH4RoV8MoOqFuBbUpPBY6XYrlIftXkmgOXduyr4w/hGFvIe20TT9yfsAXohnWG9Ty3P1A050jXSnpEZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YRdlEDQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YRdlEDQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFD5C4CEF8;
	Thu, 27 Nov 2025 22:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282427;
	bh=iOFizoi+IaSPsUp7jc4NNyyCoLfoVysCX5RtR8pBDA4=;
	h=Date:To:From:Subject:From;
	b=YRdlEDQw6hw7CObmKkqYmPgU+pdncdo+U/pfNr17w8SwyXDY1Y6g5ayY8cJCF+OoU
	 +kQka2QDtslJvnfcXkMFA5DVDJR60y19Ishlti4l5T2hHz3kNtFFvIB1HmV1lLXxSB
	 5e5+LlDunPtZTCfQFVhNZLzoD7TiU3QqEEdxqXVY=
Date: Thu, 27 Nov 2025 14:27:07 -0800
To: mm-commits@vger.kernel.org,yoann.congal@smile.fr,yesanishhere@gmail.com,yanjun.zhu@linux.dev,witu@nvidia.com,wagi@kernel.org,vincent.guittot@linaro.org,tj@kernel.org,tglx@linutronix.de,stuart.w.hayes@gmail.com,song@kernel.org,skhawaja@google.com,saeedm@nvidia.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,rdunlap@infradead.org,quic_zijuhu@quicinc.com,ptyadav@amazon.de,pratyush@kernel.org,parav@nvidia.com,ojeda@kernel.org,myungjoo.ham@samsung.com,mmaurer@google.com,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,lukas@wunner.de,linux@weissschuh.net,leonro@nvidia.com,leon@kernel.org,lennart@poettering.net,kanie@linux.alibaba.com,Jonathan.Cameron@huawei.com,joel.granados@kernel.org,jgg@nvidia.com,jannh@google.com,ira.weiny@intel.com,ilpo.jarvinen@linux.intel.com,hughd@google.com,hpa@zytor.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,graf@amazon.com,dmatlack@google.com,djeffery@redhat.com,david@redhat.com,dan.j.williams@intel.com,dakr@kernel.org,cw00.choi@samsung.com,corbet@lwn.net,chrisl@kernel.org,chenridong@huawei.com,brauner@kernel.org,bp@alien8.de,bhelgaas@google.com,bartosz.golaszewski@linaro.org,axboe@kernel.dk,anna.schumaker@oracle.com,andriy.shevchenko@linux.intel.com,aliceryhl@google.com,aleksander.lobakin@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-liveupdate-add-kexec-test-for-multiple-and-empty-sessions.patch removed from -mm tree
Message-Id: <20251127222707.CFFD5C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/liveupdate: add kexec test for multiple and empty sessions
has been removed from the -mm tree.  Its filename was
     selftests-liveupdate-add-kexec-test-for-multiple-and-empty-sessions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: selftests/liveupdate: add kexec test for multiple and empty sessions
Date: Tue, 25 Nov 2025 11:58:48 -0500

Introduce a new kexec-based selftest, luo_kexec_multi_session, to validate
the end-to-end lifecycle of a more complex LUO scenario.

While the existing luo_kexec_simple test covers the basic end-to-end
lifecycle, it is limited to a single session with one preserved file. 
This new test significantly expands coverage by verifying LUO's ability to
handle a mixed workload involving multiple sessions, some of which are
intentionally empty.  This ensures that the LUO core correctly preserves
and restores the state of all session types across a reboot.

The test validates the following sequence:

Stage 1 (Pre-kexec):

  - Creates two empty test sessions (multi-test-empty-1,
    multi-test-empty-2).
  - Creates a session with one preserved memfd (multi-test-files-1).
  - Creates another session with two preserved memfds
    (multi-test-files-2), each containing unique data.
  - Creates a state-tracking session to manage the transition to
    Stage 2.
  - Executes a kexec reboot via the helper script.

Stage 2 (Post-kexec):

  - Retrieves the state-tracking session to confirm it is in the
    post-reboot stage.
  - Retrieves all four test sessions (both the empty and non-empty
    ones).
  - For the non-empty sessions, restores the preserved memfds and
    verifies their contents match the original data patterns.
  - Finalizes all test sessions and the state session to ensure a clean
    teardown and that all associated kernel resources are correctly
    released.

This test provides greater confidence in the robustness of the LUO
framework by validating its behavior in a more realistic, multi-faceted
scenario.

Link: https://lkml.kernel.org/r/20251125165850.3389713-19-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: David Matlack <dmatlack@google.com>
Cc: Aleksander Lobakin <aleksander.lobakin@intel.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: anish kumar <yesanishhere@gmail.com>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Wagner <wagi@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Jeffery <djeffery@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guixin Liu <kanie@linux.alibaba.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Matthew Maurer <mmaurer@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Myugnjoo Ham <myungjoo.ham@samsung.com>
Cc: Parav Pandit <parav@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Song Liu <song@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: William Tu <witu@nvidia.com>
Cc: Yoann Congal <yoann.congal@smile.fr>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/liveupdate/Makefile            |    1 
 tools/testing/selftests/liveupdate/luo_multi_session.c |  162 ++++++++++
 2 files changed, 163 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/luo_multi_session.c a/tools/testing/selftests/liveupdate/luo_multi_session.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/liveupdate/luo_multi_session.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * A selftest to validate the end-to-end lifecycle of multiple LUO sessions
+ * across a kexec reboot, including empty sessions and sessions with multiple
+ * files.
+ */
+
+#include "luo_test_utils.h"
+
+#define SESSION_EMPTY_1 "multi-test-empty-1"
+#define SESSION_EMPTY_2 "multi-test-empty-2"
+#define SESSION_FILES_1 "multi-test-files-1"
+#define SESSION_FILES_2 "multi-test-files-2"
+
+#define MFD1_TOKEN 0x1001
+#define MFD2_TOKEN 0x2002
+#define MFD3_TOKEN 0x3003
+
+#define MFD1_DATA "Data for session files 1"
+#define MFD2_DATA "First file for session files 2"
+#define MFD3_DATA "Second file for session files 2"
+
+#define STATE_SESSION_NAME "kexec_multi_state"
+#define STATE_MEMFD_TOKEN 998
+
+/* Stage 1: Executed before the kexec reboot. */
+static void run_stage_1(int luo_fd)
+{
+	int s_empty1_fd, s_empty2_fd, s_files1_fd, s_files2_fd;
+
+	ksft_print_msg("[STAGE 1] Starting pre-kexec setup for multi-session test...\n");
+
+	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
+	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
+
+	ksft_print_msg("[STAGE 1] Creating empty sessions '%s' and '%s'...\n",
+		       SESSION_EMPTY_1, SESSION_EMPTY_2);
+	s_empty1_fd = luo_create_session(luo_fd, SESSION_EMPTY_1);
+	if (s_empty1_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_EMPTY_1);
+
+	s_empty2_fd = luo_create_session(luo_fd, SESSION_EMPTY_2);
+	if (s_empty2_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_EMPTY_2);
+
+	ksft_print_msg("[STAGE 1] Creating session '%s' with one memfd...\n",
+		       SESSION_FILES_1);
+
+	s_files1_fd = luo_create_session(luo_fd, SESSION_FILES_1);
+	if (s_files1_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_FILES_1);
+	if (create_and_preserve_memfd(s_files1_fd, MFD1_TOKEN, MFD1_DATA) < 0) {
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  MFD1_TOKEN);
+	}
+
+	ksft_print_msg("[STAGE 1] Creating session '%s' with two memfds...\n",
+		       SESSION_FILES_2);
+
+	s_files2_fd = luo_create_session(luo_fd, SESSION_FILES_2);
+	if (s_files2_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_FILES_2);
+	if (create_and_preserve_memfd(s_files2_fd, MFD2_TOKEN, MFD2_DATA) < 0) {
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  MFD2_TOKEN);
+	}
+	if (create_and_preserve_memfd(s_files2_fd, MFD3_TOKEN, MFD3_DATA) < 0) {
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  MFD3_TOKEN);
+	}
+
+	close(luo_fd);
+	daemonize_and_wait();
+}
+
+/* Stage 2: Executed after the kexec reboot. */
+static void run_stage_2(int luo_fd, int state_session_fd)
+{
+	int s_empty1_fd, s_empty2_fd, s_files1_fd, s_files2_fd;
+	int mfd1, mfd2, mfd3, stage;
+
+	ksft_print_msg("[STAGE 2] Starting post-kexec verification...\n");
+
+	restore_and_read_stage(state_session_fd, STATE_MEMFD_TOKEN, &stage);
+	if (stage != 2) {
+		fail_exit("Expected stage 2, but state file contains %d",
+			  stage);
+	}
+
+	ksft_print_msg("[STAGE 2] Retrieving all sessions...\n");
+	s_empty1_fd = luo_retrieve_session(luo_fd, SESSION_EMPTY_1);
+	if (s_empty1_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_EMPTY_1);
+
+	s_empty2_fd = luo_retrieve_session(luo_fd, SESSION_EMPTY_2);
+	if (s_empty2_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_EMPTY_2);
+
+	s_files1_fd = luo_retrieve_session(luo_fd, SESSION_FILES_1);
+	if (s_files1_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_FILES_1);
+
+	s_files2_fd = luo_retrieve_session(luo_fd, SESSION_FILES_2);
+	if (s_files2_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_FILES_2);
+
+	ksft_print_msg("[STAGE 2] Verifying contents of session '%s'...\n",
+		       SESSION_FILES_1);
+	mfd1 = restore_and_verify_memfd(s_files1_fd, MFD1_TOKEN, MFD1_DATA);
+	if (mfd1 < 0)
+		fail_exit("restore_and_verify_memfd for token %#x", MFD1_TOKEN);
+	close(mfd1);
+
+	ksft_print_msg("[STAGE 2] Verifying contents of session '%s'...\n",
+		       SESSION_FILES_2);
+
+	mfd2 = restore_and_verify_memfd(s_files2_fd, MFD2_TOKEN, MFD2_DATA);
+	if (mfd2 < 0)
+		fail_exit("restore_and_verify_memfd for token %#x", MFD2_TOKEN);
+	close(mfd2);
+
+	mfd3 = restore_and_verify_memfd(s_files2_fd, MFD3_TOKEN, MFD3_DATA);
+	if (mfd3 < 0)
+		fail_exit("restore_and_verify_memfd for token %#x", MFD3_TOKEN);
+	close(mfd3);
+
+	ksft_print_msg("[STAGE 2] Test data verified successfully.\n");
+
+	ksft_print_msg("[STAGE 2] Finalizing all test sessions...\n");
+	if (luo_session_finish(s_empty1_fd) < 0)
+		fail_exit("luo_session_finish for '%s'", SESSION_EMPTY_1);
+	close(s_empty1_fd);
+
+	if (luo_session_finish(s_empty2_fd) < 0)
+		fail_exit("luo_session_finish for '%s'", SESSION_EMPTY_2);
+	close(s_empty2_fd);
+
+	if (luo_session_finish(s_files1_fd) < 0)
+		fail_exit("luo_session_finish for '%s'", SESSION_FILES_1);
+	close(s_files1_fd);
+
+	if (luo_session_finish(s_files2_fd) < 0)
+		fail_exit("luo_session_finish for '%s'", SESSION_FILES_2);
+	close(s_files2_fd);
+
+	ksft_print_msg("[STAGE 2] Finalizing state session...\n");
+	if (luo_session_finish(state_session_fd) < 0)
+		fail_exit("luo_session_finish for state session");
+	close(state_session_fd);
+
+	ksft_print_msg("\n--- MULTI-SESSION KEXEC TEST PASSED ---\n");
+}
+
+int main(int argc, char *argv[])
+{
+	return luo_test(argc, argv, STATE_SESSION_NAME,
+			run_stage_1, run_stage_2);
+}
--- a/tools/testing/selftests/liveupdate/Makefile~selftests-liveupdate-add-kexec-test-for-multiple-and-empty-sessions
+++ a/tools/testing/selftests/liveupdate/Makefile
@@ -5,6 +5,7 @@ LIB_C += luo_test_utils.c
 TEST_GEN_PROGS += liveupdate
 
 TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
+TEST_GEN_PROGS_EXTENDED += luo_multi_session
 
 TEST_FILES += do_kexec.sh
 
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

