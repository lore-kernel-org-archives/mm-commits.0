Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2ED152E0F;
	Tue, 20 Feb 2024 22:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467745; cv=none; b=NVu2qR+RgY0qYbhBE+ned4NnZhKzYjhCUUiHU7+UQK+g19oeEO2/zXiQPduzx2ENZsfItAn5N9UEFjPIJkpC/n3XR/dEbZpfyWBVwe6DbrWI/WixRN/hXXH7UWvGZ6yvyTR5KiE4rge9JgsFrEHW+K8SDOsq2y8U9Apl2ALbrFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467745; c=relaxed/simple;
	bh=b/kJ1SCouATWXWf3Q3W8e/oJHpPaTJs0M4QZy+iu/ss=;
	h=Date:To:From:Subject:Message-Id; b=HleGk1WUaXCkg3Lsicqe2MqT/lUkRtNloFmrwSkOgMq20EcIdN6515I1hb07C3Ahq/sc6eEOiTk2TDFaQp7L1mp7/oXFrTmjdI2x2gzeCSvnh7M+gxoY5kjVYqn6mbu/gtbfijgLkPcCbmhy0nbU8eqf16aR0yppjkdbqR0cULA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HIJX/Iy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HIJX/Iy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81885C43399;
	Tue, 20 Feb 2024 22:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467744;
	bh=b/kJ1SCouATWXWf3Q3W8e/oJHpPaTJs0M4QZy+iu/ss=;
	h=Date:To:From:Subject:From;
	b=HIJX/Iy0Jg57sd+eN+ZEK9zARepGufMxgSsspAhrXGzznFzvSj2VGHW51ZtF1qcx7
	 xEXOJpjhHG9jIQB078LdJBjKonDB7n3ZyvKXclVgHPlYGqlTBfygC1BXeybUaRfR7J
	 OOuii2MLjTaAo76AWur3JRrvYU9aBZhPMfz/RDzs=
Date: Tue, 20 Feb 2024 14:22:23 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,peter.griffin@linaro.org,terry.tritton@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-uffd-unit-test-check-if-huge-page-size-is-0.patch removed from -mm tree
Message-Id: <20240220222224.81885C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: uffd-unit-test check if huge page size is 0
has been removed from the -mm tree.  Its filename was
     selftests-mm-uffd-unit-test-check-if-huge-page-size-is-0.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Terry Tritton <terry.tritton@linaro.org>
Subject: selftests/mm: uffd-unit-test check if huge page size is 0
Date: Mon, 5 Feb 2024 14:50:56 +0000

If HUGETLBFS is not enabled then the default_huge_page_size function will
return 0 and cause a divide by 0 error. Add a check to see if the huge page
size is 0 and skip the hugetlb tests if it is.

Link: https://lkml.kernel.org/r/20240205145055.3545806-2-terry.tritton@linaro.org
Fixes: 16a45b57cbf2 ("selftests/mm: add framework for uffd-unit-test")
Signed-off-by: Terry Tritton <terry.tritton@linaro.org>
Cc: Peter Griffin <peter.griffin@linaro.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-uffd-unit-test-check-if-huge-page-size-is-0
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1517,6 +1517,12 @@ int main(int argc, char *argv[])
 				continue;
 
 			uffd_test_start("%s on %s", test->name, mem_type->name);
+			if ((mem_type->mem_flag == MEM_HUGETLB ||
+			    mem_type->mem_flag == MEM_HUGETLB_PRIVATE) &&
+			    (default_huge_page_size() == 0)) {
+				uffd_test_skip("huge page size is 0, feature missing?");
+				continue;
+			}
 			if (!uffd_feature_supported(test)) {
 				uffd_test_skip("feature missing");
 				continue;
_

Patches currently in -mm which might be from terry.tritton@linaro.org are


