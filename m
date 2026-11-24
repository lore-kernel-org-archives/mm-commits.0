Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795560979;
	b=4/wtOZcNv4QPNeYz7fDSyqvW6bhZGrWA8t7giuxYcJd7lhTnpLRtTFD+D0SWGgFuzZmZ
	 yxhZ7vgVC1eGUNFccVIgQ3YI8YkDExizdSL4kEdizfvLeSb+h94LF4t9ZZW+BeXcY82kF
	 ugbIcMBzhpmrxpTNIbgCXud710/0OR5W7HabyoDxlCiAD9mN0w8Pq/O7PILFtCopFateb
	 qQwJ/MvA51VSIUXrvvndx9PjN5rUS8vRJGVrbXqNx+i9pDj91BpMjx3Rk74MQCm0wi0/J
	 MVfElHDgFssHam+P80NHWJpWnsCW4YklK2Q8vD7yhAjZ4VrfOW5cF1wyBKIM4N97N9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795560979;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=DIZfojdEKG6QyZ1x73RSekI416iextYq5KxPUYoK/zA=;
	b=kuvGOba4OAtECPRoQMPH5Ns57OCAQi2E8OO1U0CkJMfDx2rjv6As5qBfJvGZajKAze4Z
	 RVE9P/RC6XOY6KU4GtZ6WRiTzK7pvFnUMZ3p2zzltIlezTttylUJ5R+oLGlPEThbtRxJ6
	 w+3TTWluDh2/OXRMqpBeX10luLGr7lmWgc39OAU6ViBR1WmNAg0Sm6/pOn5auSv9q83/2
	 8S5EQw1hGOztBLwyPX+DMxuNvMoPzQo6Q3k0FgfWrbMufjhfxwjA6ADF2E3LyWQwFMNzl
	 1CjcnSFp947qpkc3cV71s15zOWYPHuGMSUzN0pVF0rc+gqdjM5+daYoL1rE0JTqdUtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=VgGdmjVK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBB8606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 22:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=VgGdmjVK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416A31F000D4;
	Tue, 24 Nov 2026 22:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795560978;
	bh=DIZfojdEKG6QyZ1x73RSekI416iextYq5KxPUYoK/zA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=VgGdmjVKZHr4K2hn3ZCVCxEssqRLVAfrv0gW8a83PvEazpwryD1pVN579lbmS0hz+
	 fZbLfmqM/2OBKuWureaBhmM2qRGvvSGBJG0dS3u0Z0udGKph3QBE2Zranr7Ros7D06
	 8mXtdcEb755iedSi9CMFrCUPKtBxe+w/9kZEFBbo=
Date: Tue, 24 Nov 2026 14:56:17 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,mcroce@microsoft.com,
	bradley.morgan@linux.dev,thnkslprpt@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124082914.564587-1-thnkslprpt@gmail.com>
References: <20261124082914.564587-1-thnkslprpt@gmail.com>
Subject: + reboot-validate-reboot-cpu-against-the-possible-mask.patch added to mm-nonmm-unstable branch
Message-Id: <20261124225618.416A31F000D4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: reboot: validate reboot CPU against the possible mask
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     reboot-validate-reboot-cpu-against-the-possible-mask.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reboot-validate-reboot-cpu-against-the-possible-mask.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Avi Weiss <thnkslprpt@gmail.com>
Subject: reboot: validate reboot CPU against the possible mask
Date: Tue, 24 Nov 2026 10:29:14 +0200

reboot_setup() and cpu_store() compare CPU IDs with num_possible_cpus(),
which is a count rather than an upper bound.  With a sparse possible mask,
this rejects valid CPUs and accepts impossible IDs.  reboot_setup() also
narrows the parsed CPU number to int before checking it, allowing large
values to be truncated.

Validate against nr_cpu_ids and cpu_possible() in both interfaces.  Use
simple_strtoull() and unsigned long long for the boot option, so the value
is not narrowed before validation on 32- or 64-bit kernels.  Preserve the
comma-separated reboot= syntax.

Link: https://patch.msgid.link/20261124082914.564587-1-thnkslprpt@gmail.com
Fixes: df5b0ab3e08a ("reboot: fix overflow parsing reboot cpu number")
Fixes: 2c622ed0eaa3 ("reboot: allow to specify reboot mode via sysfs")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Bradley Morgan <bradley.morgan@linux.dev>
Closes: https://lore.kernel.org/r/20260622154216.10064-1-include@grrlz.net
Suggested-by: Bradley Morgan <bradley.morgan@linux.dev>
Link: https://lore.kernel.org/r/D92156F5-5924-45CD-BCFE-AF385BDD15CF@mainlining.org
Reviewed-by: Bradley Morgan <bradley.morgan@linux.dev>
Cc: Matteo Croce <mcroce@microsoft.com>
Cc: Petr Mladek <pmladek@suse.com>

 kernel/reboot.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/kernel/reboot.c~reboot-validate-reboot-cpu-against-the-possible-mask
+++ a/kernel/reboot.c
@@ -1147,12 +1147,11 @@ static int __init reboot_setup(char *str
 			str += str[1] == 'm' && str[2] == 'p' ? 3 : 1;
 
 			if (isdigit(str[0])) {
-				int cpu = simple_strtoul(str, NULL, 0);
+				unsigned long long cpu = simple_strtoull(str, NULL, 0);
 
-				if (cpu >= num_possible_cpus()) {
-					pr_err("Ignoring the CPU number in reboot= option. "
-					"CPU %d exceeds possible cpu number %d\n",
-					cpu, num_possible_cpus());
+				if (cpu >= nr_cpu_ids || !cpu_possible(cpu)) {
+					pr_err("Ignoring invalid CPU %llu in reboot= option\n",
+					       cpu);
 					break;
 				}
 				reboot_cpu = cpu;
@@ -1354,7 +1353,7 @@ static ssize_t cpu_store(struct kobject
 	if (rc)
 		return rc;
 
-	if (cpunum >= num_possible_cpus())
+	if (cpunum >= nr_cpu_ids || !cpu_possible(cpunum))
 		return -ERANGE;
 
 	reboot_default = 0;
_

Patches currently in -mm which might be from thnkslprpt@gmail.com are

mm-page-writeback-avoid-unnecessary-strictlimit-background-wakeups.patch
reboot-validate-reboot-cpu-against-the-possible-mask.patch

