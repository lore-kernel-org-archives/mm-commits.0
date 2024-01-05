Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEAC35F00
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FIJ9eJ3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9E0C433C7;
	Fri,  5 Jan 2024 18:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478734;
	bh=WnlyEvhApwii/K7tyPuve+23BLM2ofQOUs+fjjbeOQY=;
	h=Date:To:From:Subject:From;
	b=FIJ9eJ3UIjddDlJeH/dNHJEwcyISoc6pu0Ju2Oi+HkcENM4QEFCQmF6POuwW2c8e3
	 OUSpkKdEsxytWmOY0TpYYSlr4+iKsWkbtUtxwoXD3yOrMFE7UNU1JiSdswLJQcgnHJ
	 uuwhVu9SlrqZO59l4XyNEWjbv235n88V91ClkkEQ=
Date: Fri, 05 Jan 2024 10:18:54 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-test-if-application-doesnt-has-root-privileges.patch removed from -mm tree
Message-Id: <20240105181854.AA9E0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip test if application doesn't has root privileges
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-test-if-application-doesnt-has-root-privileges.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: skip test if application doesn't has root privileges
Date: Mon, 1 Jan 2024 13:36:13 +0500

The test depends on writing to nr_hugepages which isn't possible without
root privileges.  So skip the test in this case.

Link: https://lkml.kernel.org/r/20240101083614.1076768-2-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-skip-test-if-application-doesnt-has-root-privileges
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -173,7 +173,7 @@ int main(int argc, char **argv)
 
 	ksft_print_header();
 
-	if (prereq() != 0)
+	if (prereq() || geteuid())
 		return ksft_exit_pass();
 
 	ksft_set_plan(1);
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


