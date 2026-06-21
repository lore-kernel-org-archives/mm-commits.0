Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AB236AB72
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067157; cv=none; b=JFImEQzX3ezICjULL0Gk/EyFQb0Q3jhXIog4SEgS59nC9DcyKeKGuccU2g4Ykbut7Z88dYIWALbijsPPrMQ6sQVWIK7vecP+upRGrY1N8T8/s4SS6nblzDU//0dIZJd/SdJxGcBIxDizH8s3hb2QQO0o7rZkDAI/vy8JCDaqD14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067157; c=relaxed/simple;
	bh=7wg7MlA4UhKrVBn31UOqbPvL4LEkFn2kbvy3qqhd+GM=;
	h=Date:To:From:Subject:Message-Id; b=aoVBeRDes18oFTNi/MPl6Two365+ezExCsFjE2gSCHM5kQJSrN67SQtixoRKSl9dPIaNwbRsOPh0CYAn8YGIrndQ7xF0Cep8C0++zz8RLanGfWb5D6sVGE5a88m07KKxVYntMVzzo3HShwULmwZVAre/FZ/twKmNNPtfxDsxdLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RRHZJecx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RRHZJecx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545681F000E9;
	Sun, 21 Jun 2026 18:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067156;
	bh=zUZ4kdQbQ3VxH9ohxtm1Xo8Hf62aQ62lIfR2139RS6g=;
	h=Date:To:From:Subject;
	b=RRHZJecx31wFT4iyep7xPNsNiC5Uyh2y1OjVMaAz/fG4hfU9LIR9eSQVx3RFvHLhf
	 qLWJr5G9+iQIfUkMxBTyC3ZjhihK3Rp+LFQ53zQRPeEvtDswcwfRyK0qchNJ2uK9kE
	 wB9Y6DqMEVKtSGjt9q476eFTwVWBQzNCA4ec6CJU=
Date: Sun, 21 Jun 2026 11:39:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-vm_util-add-helpers-to-set-and-restore-shm-limits.patch removed from -mm tree
Message-Id: <20260621183916.545681F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: vm_util: add helpers to set and restore shm limits
has been removed from the -mm tree.  Its filename was
     selftests-mm-vm_util-add-helpers-to-set-and-restore-shm-limits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: vm_util: add helpers to set and restore shm limits
Date: Mon, 11 May 2026 19:28:14 +0300

hugetlb-shm and thuge-gen tests require that limits defined by
/proc/sys/kernel/{shmmax,shmall} should be higher than certain values.

Add helpers that allow setting these limits and restoring their settings
on a test exit.

They will be used later in hugetlb-shm and thuge-gen.

Link: https://lore.kernel.org/20260511162840.375890-31-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   28 +++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h |    9 ++++++++
 2 files changed, 37 insertions(+)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-vm_util-add-helpers-to-set-and-restore-shm-limits
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -760,3 +760,31 @@ void write_num(const char *path, unsigne
 	sprintf(buf, "%lu", num);
 	write_file(path, buf, strlen(buf) + 1);
 }
+
+static unsigned long shmall, shmmax;
+
+void __shm_limits_restore(void)
+{
+	if (shmmax)
+		write_num("/proc/sys/kernel/shmmax", shmmax);
+	if (shmall)
+		write_num("/proc/sys/kernel/shmall", shmall);
+}
+
+void shm_limits_prepare(unsigned long length)
+{
+	unsigned long nr = length / psize();
+	unsigned long val;
+
+	val = read_num("/proc/sys/kernel/shmmax");
+	if (val < length) {
+		write_num("/proc/sys/kernel/shmmax", length);
+		shmmax = val;
+	}
+
+	val = read_num("/proc/sys/kernel/shmall");
+	if (val < nr) {
+		write_num("/proc/sys/kernel/shmall", nr);
+		shmall = val;
+	}
+}
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-vm_util-add-helpers-to-set-and-restore-shm-limits
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -168,3 +168,12 @@ void write_file(const char *path, const
 int read_file(const char *path, char *buf, size_t buflen);
 unsigned long read_num(const char *path);
 void write_num(const char *path, unsigned long num);
+
+void shm_limits_prepare(unsigned long length);
+void __shm_limits_restore(void);
+
+#define SHM_LIMITS_RESTORE()						\
+static void __attribute__((destructor)) shm_limits_restore(void)	\
+{									\
+	__shm_limits_restore();						\
+}
_

Patches currently in -mm which might be from rppt@kernel.org are


