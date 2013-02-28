From: akpm@linux-foundation.org
Subject: [merged] selftests-efivarfs-add-empty-file-creation-test.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:18:01 -0800
Message-ID: <20130228201801.EA46D5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:64170 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab3B1USC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:18:02 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so245427ggi.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:18:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jk@ozlabs.org, dyoung@redhat.com, lxiang@redhat.com, matt.fleming@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/efivarfs: add empty file creation test
has been removed from the -mm tree.  Its filename was
     selftests-efivarfs-add-empty-file-creation-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

