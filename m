Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E42ED310;
	Fri, 26 Jan 2024 07:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255759; cv=none; b=Gp+bQUt72UcWgZUpfnmKGxIRSZ1hdQrRoehUbHvqumjuwgTVx5DbK4ZfycfbQlMHmRZhhIt7KSSv/E7Z8FMuoJZpJB65ojhaMO5TLgn4ftX2vLaYsF2IcZVUGdwH7in6vRJ4LyoxIVNaWNpKIEyn4Z56IR4SulVKvwF82dOtqiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255759; c=relaxed/simple;
	bh=ab0TfX9VfkqUFBpanhBvwDtifM6uG0wHJ0AydN4xk+0=;
	h=Date:To:From:Subject:Message-Id; b=RaM5+3TUX/+NWOHuWVFJk61qaMmIODpwQUbBGBoMHuEwi1JJT4/zmUKc5mK0VPeXQlKAuwsiRV7Dko582bRkve2zc82PrniPSlXE/AfbNJ+QEHspznyE8HHU+bjYCOZeuaKAMnxsQbV0ibuPxrjOpBntO6qMIFBTBlPgCvhFj2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mu2Ivzfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mu2Ivzfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F6FC433F1;
	Fri, 26 Jan 2024 07:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255759;
	bh=ab0TfX9VfkqUFBpanhBvwDtifM6uG0wHJ0AydN4xk+0=;
	h=Date:To:From:Subject:From;
	b=mu2Ivzfc4wiTR0ofPTqV+R1QhDeCtYONOMmFHKTpI+CtGtqk5YUCSaMYqSBMe8N0X
	 6znWuQsNKAzalBOD7HVQCAASthq7Pi2ulga5G9M4bu0kx++QVTewCxvZ8oLSuhFyVN
	 E4g9kTlIUBu8Lev/q+3U145MTdy/8xf1hX0i/sHQ=
Date: Thu, 25 Jan 2024 23:55:56 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,raquini@redhat.com,adam@wowsignal.io,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-update-va_high_addr_switchsh-to-check-cpu-for-la57-flag.patch removed from -mm tree
Message-Id: <20240126075558.89F6FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: Update va_high_addr_switch.sh to check CPU for la57 flag
has been removed from the -mm tree.  Its filename was
     selftests-mm-update-va_high_addr_switchsh-to-check-cpu-for-la57-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Audra Mitchell <audra@redhat.com>
Subject: selftests/mm: Update va_high_addr_switch.sh to check CPU for la57 flag
Date: Fri, 19 Jan 2024 15:58:01 -0500

In order for the page table level 5 to be in use, the CPU must have the
setting enabled in addition to the CONFIG option. Check for the flag to be
set to avoid false test failures on systems that do not have this cpu flag
set.

The test does a series of mmap calls including three using the
MAP_FIXED flag and specifying an address that is 1<<47 or 1<<48.  These
addresses are only available if you are using level 5 page tables,
which requires both the CPU to have the capabiltiy (la57 flag) and the
kernel to be configured.  Currently the test only checks for the kernel
configuration option, so this test can still report a false positive. 
Here are the three failing lines:

$ ./va_high_addr_switch | grep FAILED
mmap(ADDR_SWITCH_HINT, 2 * PAGE_SIZE, MAP_FIXED): 0xffffffffffffffff - FAILED
mmap(HIGH_ADDR, MAP_FIXED): 0xffffffffffffffff - FAILED
mmap(ADDR_SWITCH_HINT, 2 * PAGE_SIZE, MAP_FIXED): 0xffffffffffffffff - FAILED

I thought (for about a second) refactoring the test so that these three
mmap calls will only be run on systems with the level 5 page tables
available, but the whole point of the test is to check the level 5
feature...

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


