Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B7031A78;
	Sun, 21 Jan 2024 22:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705875235; cv=none; b=odfDJ786e9slMRyF7wuFebCdomLIhgPVNGnY7IeKdXoId8LgD0Ldtz9JZq/fnlSL/1UUUUROn8lojc4kX0b4LYnAQeraVDLrb7gQQEeI5SjL71h4O4wu+H4H0eKONUtytVpadotorL7F58i6ytNybrnR0b6btbWTrEOyosVE+cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705875235; c=relaxed/simple;
	bh=KSqALTixM5vYaqW5ZAi1Xh0NLYQMP+PJoTN5lg+7UQA=;
	h=Date:To:From:Subject:Message-Id; b=PEWodEZeZKi6Ub61jBBHiC7iworp/gL+kIqQuKPvDVa/9Dj1ArmI2qDUE3xrm9klE7fckz+5E4bjSf/2sSfxW0kzJWOmwxC9BjBT4tLkdWh1ppi64IYNB9UHmM5t7Zcn3ns3imApx1CvNPTDSpjowXa74aagU3tYBHbWCT0NePs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LM4qngJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LM4qngJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8E8C433F1;
	Sun, 21 Jan 2024 22:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705875234;
	bh=KSqALTixM5vYaqW5ZAi1Xh0NLYQMP+PJoTN5lg+7UQA=;
	h=Date:To:From:Subject:From;
	b=LM4qngJRCy71/Sj/IXxdCMei2usiK3XWLLAVYq0P90c11KuKfLxvm7rUv6AzG4wgR
	 xt79gvH/YJA4ehHDqBzLZ8AFVGWoQdZc96UXM4FoSgYYDuuzc6moZcMWr3SragB9T9
	 Zkf39TTwY0SgcFR3ktGLULrcbSO3x3OlX+4VMopI=
Date: Sun, 21 Jan 2024 14:13:50 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,raquini@redhat.com,adam@wowsignal.io,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-update-va_high_addr_switchsh-to-check-cpu-for-la57-flag.patch added to mm-hotfixes-unstable branch
Message-Id: <20240121221354.1E8E8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: Update va_high_addr_switch.sh to check CPU for la57 flag
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-update-va_high_addr_switchsh-to-check-cpu-for-la57-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-update-va_high_addr_switchsh-to-check-cpu-for-la57-flag.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Audra Mitchell <audra@redhat.com>
Subject: selftests/mm: Update va_high_addr_switch.sh to check CPU for la57 flag
Date: Fri, 19 Jan 2024 15:58:01 -0500

In order for the page table level 5 to be in use, the CPU must have the
setting enabled in addition to the CONFIG option. Check for the flag to be
set to avoid false test failures on systems that do not have this cpu flag
set.

Link: https://lkml.kernel.org/r/20240119205801.62769-1-audra@redhat.com
Fixes: 4f2930c6718a ("selftests/vm: only run 128TBswitch with 5-level paging")
Signed-off-by: Audra Mitchell <audra@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Adam Sindelar <adam@wowsignal.io>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.sh |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/mm/va_high_addr_switch.sh~selftests-mm-update-va_high_addr_switchsh-to-check-cpu-for-la57-flag
+++ a/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -29,9 +29,15 @@ check_supported_x86_64()
 	# See man 1 gzip under '-f'.
 	local pg_table_levels=$(gzip -dcfq "${config}" | grep PGTABLE_LEVELS | cut -d'=' -f 2)
 
+	local cpu_supports_pl5=$(awk '/^flags/ {if (/la57/) {print 0;}
+		else {print 1}; exit}' /proc/cpuinfo 2>/dev/null)
+
 	if [[ "${pg_table_levels}" -lt 5 ]]; then
 		echo "$0: PGTABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
 		exit $ksft_skip
+	elif [[ "${cpu_supports_pl5}" -ne 0 ]]; then
+		echo "$0: CPU does not have the necessary la57 flag to support page table level 5"
+		exit $ksft_skip
 	fi
 }
 
_

Patches currently in -mm which might be from audra@redhat.com are

selftests-mm-update-va_high_addr_switchsh-to-check-cpu-for-la57-flag.patch

