From: akpm@linux-foundation.org
Subject: [merged] samples-seccomp-improve-label-helper.patch removed from
 -mm tree
Date: Wed, 18 Feb 2015 11:44:53 -0800
Message-ID: <54e4ebb5.SYsgm2FG70VOmbeJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbbBRToy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, swiecki@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: samples/seccomp: improve label helper
has been removed from the -mm tree.  Its filename was
     samples-seccomp-improve-label-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: samples/seccomp: improve label helper

Fixes a potential corruption with uninitialized stack memory in the
seccomp BPF sample program.

[akpm@linux-foundation.org: coding-style fixlet]
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Robert Swiecki <swiecki@google.com>
Tested-by: Robert Swiecki <swiecki@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/seccomp/bpf-fancy.c  |    4 +++-
 samples/seccomp/bpf-helper.c |    6 ++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN samples/seccomp/bpf-fancy.c~samples-seccomp-improve-label-helper samples/seccomp/bpf-fancy.c
--- a/samples/seccomp/bpf-fancy.c~samples-seccomp-improve-label-helper
+++ a/samples/seccomp/bpf-fancy.c
@@ -25,7 +25,9 @@
 
 int main(int argc, char **argv)
 {
-	struct bpf_labels l;
+	struct bpf_labels l = {
+		.count = 0,
+	};
 	static const char msg1[] = "Please type something: ";
 	static const char msg2[] = "You typed: ";
 	char buf[256];
diff -puN samples/seccomp/bpf-helper.c~samples-seccomp-improve-label-helper samples/seccomp/bpf-helper.c
--- a/samples/seccomp/bpf-helper.c~samples-seccomp-improve-label-helper
+++ a/samples/seccomp/bpf-helper.c
@@ -10,6 +10,7 @@
  */
 
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
 
 #include "bpf-helper.h"
@@ -63,6 +64,11 @@ __u32 seccomp_bpf_label(struct bpf_label
 {
 	struct __bpf_label *begin = labels->labels, *end;
 	int id;
+
+	if (labels->count == BPF_LABELS_MAX) {
+		fprintf(stderr, "Too many labels\n");
+		exit(1);
+	}
 	if (labels->count == 0) {
 		begin->label = label;
 		begin->location = 0xffffffff;
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
aslr-fix-stack-randomization-on-64-bit-systems.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch

