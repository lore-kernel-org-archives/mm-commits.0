Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE65214A89
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188443; cv=none; b=HVdUlIKzVFmd6HFUsBVgOi5a505oCGrXI3v08eNeKkFHmkHZPmuBiAOnfDc5WHC3S3ZHORWh9ML39hydk7O1NQryf9khOqICmAHnKwPYtv8vrN7qJT01kso3hfWCxEmYYGRPy3uUAA6kwtCirivwmxHSGPmEr79s0Lnal/8F7g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188443; c=relaxed/simple;
	bh=dEFOvtmeN8aANDjZsypCPN3AzzGcu8iNFuyZScCG/FE=;
	h=Date:To:From:Subject:Message-Id; b=c0bqb8iCcsIbreZkIHxNqFz9loLQ3cP2eMH719NI6n/PQnnOxoyaBnERb/+yW14rf1odwUtMN8Vrd8PfvVY7ORTysrvIwn3N+Gslikkk4sDnHNAXHkBTQ5qh7U5H/gQ/V2oXSIcSHpfJcFtUS9Dy0rrdF/4mnAPLgyB5D2D7xFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d0PW95g4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d0PW95g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AD1C4CEEC;
	Mon, 17 Mar 2025 05:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188442;
	bh=dEFOvtmeN8aANDjZsypCPN3AzzGcu8iNFuyZScCG/FE=;
	h=Date:To:From:Subject:From;
	b=d0PW95g49OTS9A91b2Dwq246c2x5RNq1gD+38s/v0aTk17a6LYDS8HtC2dtHJL2EQ
	 6cd9JtOgkH8np+va+AsC/h+7FXHlCA1ZpoaCZl/YNkexvrYV0GRatLcVTgrZMDpeEA
	 kgBAiwJYUqmDLoIQ8xAI73vsT572cc6ODp7XAyb8=
Date: Sun, 16 Mar 2025 22:14:02 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch removed from -mm tree
Message-Id: <20250317051402.D6AD1C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: don't fail uffd-stress if too many CPUs
has been removed from the -mm tree.  Its filename was
     selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: don't fail uffd-stress if too many CPUs
Date: Tue, 11 Mar 2025 13:18:17 +0000

This calculation divides a fixed parameter by an environment-dependent
parameter i.e.  the number of CPUs.

The simple way to avoid machine-specific failures here is to just put a
cap on the max value of the latter.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-6-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-dont-fail-uffd-stress-if-too-many-cpus
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -435,6 +435,7 @@ static void sigalrm(int sig)
 
 int main(int argc, char **argv)
 {
+	unsigned long nr_cpus;
 	size_t bytes;
 
 	if (argc < 4)
@@ -453,7 +454,15 @@ int main(int argc, char **argv)
 		return KSFT_SKIP;
 	}
 
-	nr_parallel = sysconf(_SC_NPROCESSORS_ONLN);
+	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	if (nr_cpus > 32) {
+		/* Don't let calculation below go to zero. */
+		ksft_print_msg("_SC_NPROCESSORS_ONLN (%lu) too large, capping nr_threads to 32\n",
+			       nr_cpus);
+		nr_parallel = 32;
+	} else {
+		nr_parallel = nr_cpus;
+	}
 
 	nr_pages_per_cpu = bytes / page_size / nr_parallel;
 	if (!nr_pages_per_cpu) {
_

Patches currently in -mm which might be from jackmanb@google.com are

scripts-gdb-add-lx_per_cpu_ptr.patch

