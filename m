Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2429F23C710
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837045; cv=none; b=sjMFQujcG0yhSRrAXzmkJzzzR+iDGXBp8L0d2xC4ySBfESxqfyAG2ckyvc/bq2BEVMomYxbscIw2Sngmb92zP7cn7LGZAwoMApqavP+aUI5geYEjQXEL9cFl4fD4PxdlNZz2X4zD44z/cpDtT6plZMszjAVJeCXZKZoflI/7/04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837045; c=relaxed/simple;
	bh=td9XuAFyTxafUnErHMexz1IAMaDdXfcdiK3gN4DuBGQ=;
	h=Date:To:From:Subject:Message-Id; b=s95KuViIVZ7pf63JcxeGya4qMzRhnRUWKS7iwMERLjS9o8mldSZDfdNEgP2jF9gUe/CU2EWu2Jc7pInT16FumuK5US6t/zwAyfQ9guTh8r6L8Jo/e6H7qnNHpdZxj4nvR0xyE+q4lh2SG92CosRawfXbFAwgg48DsNOm9i++nYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ibItr043; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ibItr043"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF9DC4CEDD;
	Tue, 14 Jan 2025 06:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837045;
	bh=td9XuAFyTxafUnErHMexz1IAMaDdXfcdiK3gN4DuBGQ=;
	h=Date:To:From:Subject:From;
	b=ibItr043orF9En6ra4JG0VpUFUQxZUpR90OW+8Evg89IdHkkkdaNp7Lb7153yFQ5y
	 JTLG99EOFHtrBQ8RcMJWWpNkLPL4Ry9QfJEwj3DBN/fWDxYNcDP2xSdgLE+6oeW5kf
	 h0OB7lHO3MJfwZQmQOm4dZmcu/86GHBcHOGCh2c8=
Date: Mon, 13 Jan 2025 22:44:04 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-build-with-o2.patch removed from -mm tree
Message-Id: <20250114064404.EEF9DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: build with -O2
has been removed from the -mm tree.  Its filename was
     selftests-mm-build-with-o2.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: build with -O2
Date: Mon, 9 Dec 2024 09:50:10 +0000

The mm kselftests are currently built with no optimisation (-O0).  It's
unclear why, and besides being obviously suboptimal, this also prevents
the pkeys tests from working as intended.  Let's build all the tests with
-O2.

[kevin.brodsky@arm.com: silence unused-result warnings]
  Link: https://lkml.kernel.org/r/20250107170110.2819685-1-kevin.brodsky@arm.com
Link: https://lkml.kernel.org/r/20241209095019.1732120-6-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-build-with-o2
+++ a/tools/testing/selftests/mm/Makefile
@@ -33,9 +33,16 @@ endif
 # LDLIBS.
 MAKEFLAGS += --no-builtin-rules
 
-CFLAGS = -Wall -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
+CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
 LDLIBS = -lrt -lpthread -lm
 
+# Some distributions (such as Ubuntu) configure GCC so that _FORTIFY_SOURCE is
+# automatically enabled at -O1 or above. This triggers various unused-result
+# warnings where functions such as read() or write() are called and their
+# return value is not checked. Disable _FORTIFY_SOURCE to silence those
+# warnings.
+CFLAGS += -U_FORTIFY_SOURCE
+
 KDIR ?= /lib/modules/$(shell uname -r)/build
 ifneq (,$(wildcard $(KDIR)/Module.symvers))
 ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


