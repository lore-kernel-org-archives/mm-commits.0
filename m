From: akpm@linux-foundation.org
Subject: + samples-seccomp-improve-label-helper.patch added to -mm tree
Date: Tue, 03 Feb 2015 14:23:50 -0800
Message-ID: <54d14a76.RjUYeUVj8wi+AGp6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbbBCWXv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2015 17:23:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, swiecki@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: samples/seccomp: improve label helper
has been added to the -mm tree.  Its filename is
     samples-seccomp-improve-label-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/samples-seccomp-improve-label-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/samples-seccomp-improve-label-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: samples/seccomp: improve label helper

Fixes a potential corruption with uninitialized stack memory in the
seccomp BPF sample program.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Robert Swiecki <swiecki@google.com>
Tested-by: Robert Swiecki <swiecki@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/seccomp/bpf-fancy.c  |    4 +++-
 samples/seccomp/bpf-helper.c |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)

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
@@ -63,6 +64,10 @@ __u32 seccomp_bpf_label(struct bpf_label
 {
 	struct __bpf_label *begin = labels->labels, *end;
 	int id;
+	if (labels->count == BPF_LABELS_MAX) {
+		fprintf(stderr, "Too many labels\n");
+		exit(1);
+	}
 	if (labels->count == 0) {
 		begin->label = label;
 		begin->location = 0xffffffff;
_

Patches currently in -mm which might be from keescook@chromium.org are

docs-procs-describe-proc-pid-map_files-entry.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch
lib-vsprintf-add-%pt-format-specifier.patch
samples-seccomp-improve-label-helper.patch
linux-next.patch

