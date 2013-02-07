From: akpm@linux-foundation.org
Subject: + selftests-efivarfs-add-empty-file-creation-test.patch added to -mm tree
Date: Thu, 07 Feb 2013 15:14:55 -0800
Message-ID: <20130207231456.7D8401CA1CF@corp2gmr1-1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:34195 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759425Ab3BGXO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2013 18:14:59 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so103942fae.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Feb 2013 15:14:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jk@ozlabs.org, dyoung@redhat.com, lxiang@redhat.com, matt.fleming@intel.com


The patch titled
     Subject: selftests/efivarfs: add empty file creation test
has been added to the -mm tree.  Its filename is
     selftests-efivarfs-add-empty-file-creation-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeremy Kerr <jk@ozlabs.org>
Subject: selftests/efivarfs: add empty file creation test

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Lingzhu Xiang <lxiang@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/efivarfs/efivarfs.sh |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN tools/testing/selftests/efivarfs/efivarfs.sh~selftests-efivarfs-add-empty-file-creation-test tools/testing/selftests/efivarfs/efivarfs.sh
--- a/tools/testing/selftests/efivarfs/efivarfs.sh~selftests-efivarfs-add-empty-file-creation-test
+++ a/tools/testing/selftests/efivarfs/efivarfs.sh
@@ -58,6 +58,18 @@ test_create()
 	fi
 }
 
+test_create_empty()
+{
+	local file=$efivarfs_mount/$FUNCNAME-$test_guid
+
+	: > $file
+
+	if [ ! -e $file ]; then
+		echo "$file can not be created without writing" >&2
+		exit 1
+	fi
+}
+
 test_delete()
 {
 	local attrs='\x07\x00\x00\x00'
@@ -112,6 +124,7 @@ check_prereqs
 rc=0
 
 run_test test_create
+run_test test_create_empty
 run_test test_delete
 run_test test_zero_size_delete
 run_test test_open_unlink
_

Patches currently in -mm which might be from jk@ozlabs.org are

selftests-add-tests-for-efivarfs.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-efivarfs-add-empty-file-creation-test.patch
selftests-efivarfs-add-create-read-test.patch

