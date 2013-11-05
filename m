From: akpm@linux-foundation.org
Subject: + kprobes-use-ksym_name_len-to-size-identifier-buffers.patch
 added to -mm tree
Date: Tue, 05 Nov 2013 14:34:22 -0800
Message-ID: <5279726e.OiQHW5g7UgcAcUyE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3KEWeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 17:34:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ananth@in.ibm.com, ak@linux.intel.com, jmario@redhat.com

Subject: + kprobes-use-ksym_name_len-to-size-identifier-buffers.patch added to -mm tree
To: jmario@redhat.com,ak@linux.intel.com,ananth@in.ibm.com
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 14:34:22 -0800


The patch titled
     Subject: kprobes: use KSYM_NAME_LEN to size identifier buffers
has been added to the -mm tree.  Its filename is
     kprobes-use-ksym_name_len-to-size-identifier-buffers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kprobes-use-ksym_name_len-to-size-identifier-buffers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kprobes-use-ksym_name_len-to-size-identifier-buffers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Mario <jmario@redhat.com>
Subject: kprobes: use KSYM_NAME_LEN to size identifier buffers

Use KSYM_NAME_LEN to size identifier buffers, so that it can be easier
increased.

Signed-off-by: Joe Mario <jmario@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kprobes.c~kprobes-use-ksym_name_len-to-size-identifier-buffers kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-use-ksym_name_len-to-size-identifier-buffers
+++ a/kernel/kprobes.c
@@ -2066,7 +2066,7 @@ static int __init init_kprobes(void)
 {
 	int i, err = 0;
 	unsigned long offset = 0, size = 0;
-	char *modname, namebuf[128];
+	char *modname, namebuf[KSYM_NAME_LEN];
 	const char *symbol_name;
 	void *addr;
 	struct kprobe_blackpoint *kb;
@@ -2192,7 +2192,7 @@ static int __kprobes show_kprobe_addr(st
 	const char *sym = NULL;
 	unsigned int i = *(loff_t *) v;
 	unsigned long offset = 0;
-	char *modname, namebuf[128];
+	char *modname, namebuf[KSYM_NAME_LEN];
 
 	head = &kprobe_table[i];
 	preempt_disable();
_

Patches currently in -mm which might be from jmario@redhat.com are

kprobes-use-ksym_name_len-to-size-identifier-buffers.patch
linux-next.patch

