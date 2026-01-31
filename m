Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE5320CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898309; cv=none; b=XADR8u4gPDYjlDj4yhtlWJfiNFSoqI7TzB3ZlURBKlrlDX2MYdLbulvKojiq/WCV9oMcev7Dzf+bXGH7pjS77OO2MavoLuV2CMt2YvKMCwItnVksa2A8ivs2q3NQNNrMuyeHLYzd1CPd525Ulo2FkYRtnwnoFOfVDtpfWoVaFYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898309; c=relaxed/simple;
	bh=3ePwD6vEKus0XFIsbRlq2h4Kz2iLL6nrcDIrAQnZyhk=;
	h=Date:To:From:Subject:Message-Id; b=Cf2zxBj0FrXYGkxO01hL8+23XUmDMurpc8dEpGXtiyP+4hXqFMwKKkQOc3MLvwwyUO9qTY6qTLEflwb8Rs1ham/+NOhiWjgNKc1UGcQ2pK2/dGskYm1OGMQg7b49ozDdKSydIHZzBp+/GfMScEltwxb8HCYiSzPXt60x9IynlxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lNKrYCIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lNKrYCIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AEAC4CEF1;
	Sat, 31 Jan 2026 22:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898309;
	bh=3ePwD6vEKus0XFIsbRlq2h4Kz2iLL6nrcDIrAQnZyhk=;
	h=Date:To:From:Subject:From;
	b=lNKrYCIFrZFyfE1ofOBVZBC9qdFwe4Rk++xIjgNgEeYItfYfOMVep2/103jp87HGO
	 p7iQ3pWKSCOhUIdak6bqREsN/Wf3oNKteeQVe2HufzjDImUXwVhM3U7hIK5btZhKGo
	 VeU7MTLipcAPjcarXnyWb0jT7HMnOy6P1l7jA6QI=
Date: Sat, 31 Jan 2026 14:25:09 -0800
To: mm-commits@vger.kernel.org,Usama.Anjum@arm.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,pabeni@redhat.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,lianux.mm@gmail.com,jhubbard@nvidia.com,jgg@nvidia.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch removed from -mm tree
Message-Id: <20260131222509.A4AEAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: pass down full CC and CFLAGS to check_config.sh
has been removed from the -mm tree.  Its filename was
     selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: pass down full CC and CFLAGS to check_config.sh
Date: Thu, 22 Jan 2026 17:02:18 +0000

check_config.sh checks that liburing is available by running the compiler
provided as its first argument.  This makes two assumptions:

1. CC consists of only one word
2. No extra flag is required

Unfortunately, there are many situations where these assumptions don't
hold.  For instance:

- When using Clang, CC consists of multiple words
- When cross-compiling, extra flags may be required to allow the
  compiler to find headers

Remove these assumptions by passing down CC and CFLAGS as-is from the
Makefile, so that the same command line is used as when actually building
the tests.

Link: https://lkml.kernel.org/r/20260122170224.4056513-4-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile        |    2 +-
 tools/testing/selftests/mm/check_config.sh |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/check_config.sh~selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh
+++ a/tools/testing/selftests/mm/check_config.sh
@@ -16,8 +16,7 @@ echo "#include <sys/types.h>"        > $
 echo "#include <liburing.h>"        >> $tmpfile_c
 echo "int func(void) { return 0; }" >> $tmpfile_c
 
-CC=${1:?"Usage: $0 <compiler> # example compiler: gcc"}
-$CC -c $tmpfile_c -o $tmpfile_o >/dev/null 2>&1
+$CC $CFLAGS -c $tmpfile_c -o $tmpfile_o
 
 if [ -f $tmpfile_o ]; then
     echo "#define LOCAL_CONFIG_HAVE_LIBURING 1"  > $OUTPUT_H_FILE
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh
+++ a/tools/testing/selftests/mm/Makefile
@@ -230,7 +230,7 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
 local_config.mk local_config.h: check_config.sh
-	/bin/sh ./check_config.sh $(CC)
+	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
 EXTRA_CLEAN += local_config.mk local_config.h
 
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


