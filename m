From: akpm@linux-foundation.org
Subject: +
 aoe-remove-do-nothing-name=%k-term-from-example-udev-rules.patch added to
 -mm tree
Date: Wed, 28 Aug 2013 14:12:49 -0700
Message-ID: <521e67d1.GiR61Gj2yxgOCSlG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab3H1VMu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Aug 2013 17:12:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com

Subject: + aoe-remove-do-nothing-name=%k-term-from-example-udev-rules.patch added to -mm tree
To: ecashin@coraid.com
From: akpm@linux-foundation.org
Date: Wed, 28 Aug 2013 14:12:49 -0700


The patch titled
     Subject: aoe: remove do-nothing NAME="%k" term from example udev rules
has been added to the -mm tree.  Its filename is
     aoe-remove-do-nothing-name=%k-term-from-example-udev-rules.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/aoe-remove-do-nothing-name=%k-term-from-example-udev-rules.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/aoe-remove-do-nothing-name=%k-term-from-example-udev-rules.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: remove do-nothing NAME="%k" term from example udev rules

When the example udev rules in the documentation are used without
modification, warnings like the one shown below appear in the system logs:

  /var/log/messages:Aug 22 11:09:11 kung udevd[445]: NAME="%k" \
    is superfluous and breaks kernel supplied names, please remove \
    it from /etc/udev/rules.d/60-aoe.rules:26

Removing the term does not cause any problems with the creation of the
special character and block device nodes.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/aoe/udev.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/aoe/udev.txt~aoe-remove-do-nothing-name=%k-term-from-example-udev-rules Documentation/aoe/udev.txt
--- a/Documentation/aoe/udev.txt~aoe-remove-do-nothing-name=%k-term-from-example-udev-rules
+++ a/Documentation/aoe/udev.txt
@@ -23,4 +23,4 @@ SUBSYSTEM=="aoe", KERNEL=="revalidate",
 SUBSYSTEM=="aoe", KERNEL=="flush",	NAME="etherd/%k", GROUP="disk", MODE="0220"
 
 # aoe block devices     
-KERNEL=="etherd*",       NAME="%k", GROUP="disk"
+KERNEL=="etherd*",       GROUP="disk"
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-create-and-destroy-debugfs-directory-for-aoe.patch
aoe-add-aoe-target-files-to-debugfs.patch
aoe-provide-file-operations-for-debugfs-files.patch
aoe-fill-in-per-aoe-target-information-for-debugfs-file.patch
aoe-update-copyright-date.patch
aoe-update-internal-version-number-to-85.patch
aoe-remove-custom-implementation-of-kbasename.patch
aoe-suppress-compiler-warnings.patch
aoe-do-not-bug-if-memory-pressure-prevented-debugfs-file-creation.patch
aoe-remove-do-nothing-name=%k-term-from-example-udev-rules.patch

