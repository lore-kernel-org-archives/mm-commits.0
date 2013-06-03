From: akpm@linux-foundation.org
Subject: +
 kprobes-handle-empty-invalid-input-to-debugfs-enabled-file.patch added to
 -mm tree
Date: Mon, 03 Jun 2013 15:58:29 -0700
Message-ID: <51ad1f95.e0MfXMZy9CC47e1h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab3FCW6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 18:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, masami.hiramatsu.pt@hitachi.com, davem@davemloft.net, anil.s.keshavamurthy@intel.com, ananth@in.ibm.com, minipli@googlemail.com

Subject: + kprobes-handle-empty-invalid-input-to-debugfs-enabled-file.patch added to -mm tree
To: minipli@googlemail.com,ananth@in.ibm.com,anil.s.keshavamurthy@intel.com,davem@davemloft.net,masami.hiramatsu.pt@hitachi.com
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 15:58:29 -0700


The patch titled
     Subject: kprobes: handle empty/invalid input to debugfs "enabled" file
has been added to the -mm tree.  Its filename is
     kprobes-handle-empty-invalid-input-to-debugfs-enabled-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mathias Krause <minipli@googlemail.com>
Subject: kprobes: handle empty/invalid input to debugfs "enabled" file

When writing invalid input to 'debug/kprobes/enabled' it'll silently be
ignored.  Even worse, when writing an empty string to this file, the
outcome is purely random as the switch statement will make its decision
based on the value of an uninitialized stack variable.

Fix this by handling invalid/empty input as error returning -EINVAL.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/kprobes.c~kprobes-handle-empty-invalid-input-to-debugfs-enabled-file kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-handle-empty-invalid-input-to-debugfs-enabled-file
+++ a/kernel/kprobes.c
@@ -2322,6 +2322,7 @@ static ssize_t write_enabled_file_bool(s
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
+	buf[buf_size] = '\0';
 	switch (buf[0]) {
 	case 'y':
 	case 'Y':
@@ -2333,6 +2334,8 @@ static ssize_t write_enabled_file_bool(s
 	case '0':
 		disarm_all_kprobes();
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	return count;
_

Patches currently in -mm which might be from minipli@googlemail.com are

kprobes-handle-empty-invalid-input-to-debugfs-enabled-file.patch

