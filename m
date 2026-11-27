Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795743075;
	b=wbQKv+8RIFbjf8ugE6hLTQRciyy+tF6KN7GDWdy/kbZ7MJ3NhWMPv5fRkTUxqJAKCIB6
	 OxeKeUhZ1qyWgQB/C3QURtwzK2VRqWrQS5vNNtholIm2Ftz+Qpn6n65Uuh55lfzUEC1rp
	 kVJg/p6gSDJXa8KSzb1QAsAmsnx32IbcNPFsGgHUt6+XWphNGEv5TNw0rnaSy7T4cQMwe
	 6xI0MecYOf2rbaj9aCnukgj7y1rAds2AfCkk6wT+ItTfU8Y4UMf3VbZOwP1g6QqtEnIgc
	 osNhpadMFG5eBIiA8TqpGpmzxYLYqVKqePclUhkMLIoJjlOlAvdbbmdPzS3CAxNYlWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795743075;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=b0RfJ7zj6Dd06YQ5HF1deKUwj5kXFOHZR1bwxb4Q4cE=;
	b=2CeW1/galQkf8UiwX0+dg5Y1zyNiBS2i2FNqRhVqgZcnYAHyaVv4jbPh8Kwv4BQ6EEUl
	 +NWKHf2xzDpF10lMPX7Wd7CVgkI/JTAun1AhhXnFciZ/fEnBsSA3eYjbwVXG9pmJiLu+M
	 CLfiO2eTy38n8nmsE2ToqmQ2e3/xZHM9jSQ6RJyCY7/LX1J50bs+aY3ch+KDXdqhfuBOf
	 +/RI1vVZh/OOeCAzahiHXhW1RAe0Crnx/ltSaskWvYaAyBgQOsiiSqfoDL2uhQzCJEgwO
	 QXeeFJd99LF6PRkQdbjnrliRqDymjOlI3e9eCcQr8zOHDaT/RW9MGu3mbFmgZCAXPJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TPkHh+gw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A28606A31C
	for <mm-commits@vger.kernel.org>; Fri, 27 Nov 2026 01:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TPkHh+gw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F40F1F00893;
	Fri, 27 Nov 2026 01:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795743075;
	bh=b0RfJ7zj6Dd06YQ5HF1deKUwj5kXFOHZR1bwxb4Q4cE=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=TPkHh+gwZ+pynANbgJUSZf1IdFz0PWYvhSYH7KrO/BfM5looR0mJla7EIqYeTJezj
	 8lXQCuqQyfCtpwA3y9lNz1dEQy5i16XiuV1d3UiE2/Cr0yJ9KS6RStPKsUHqrVuaez
	 m3KbejMr3+0OYSHMw+UDLRAbF/kIN1xa6r8sJxpQ=
Date: Thu, 26 Nov 2026 17:31:14 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,skhan@linuxfoundation.org,
	shakeel.butt@linux.dev,roman.gushchin@linux.dev,rdunlap@infradead.org,
	muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,mhocko@kernel.org,
	hannes@cmpxchg.org,corbet@lwn.net,xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-memcg-reclain-stat-v1-1-c6cb14b0d917@gmail.com>
References: <20261124-memcg-reclain-stat-v1-1-c6cb14b0d917@gmail.com>
Subject: + mm-memcontrol-expose-anon-and-file-reclaim-statistics-in-memorystat.patch added to mm-new branch
Message-Id: <20261127013115.3F40F1F00893@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/memcontrol: expose anon and file reclaim statistics in memory.stat
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-expose-anon-and-file-reclaim-statistics-in-memorystat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-expose-anon-and-file-reclaim-statistics-in-memorystat.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: mm/memcontrol: expose anon and file reclaim statistics in memory.stat
Date: Tue, 24 Nov 2026 15:51:27 +0800

The aggregate reclaim counters in memory.stat do not show how reclaim is
split between the anonymous and file LRUs of a cgroup.

Expose the existing per-memcg scan and steal counters by LRU type so
userspace can measure reclaim balance and efficiency when evaluating
reclaim policy.  Report the same counters per node in memory.numa_stat. 
Both files report the counters in base pages.

Link: https://patch.msgid.link/20261124-memcg-reclain-stat-v1-1-c6cb14b0d917@gmail.com
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>

 Documentation/admin-guide/cgroup-v2.rst |   20 ++++++++++++++++++--
 mm/memcontrol.c                         |    8 ++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-expose-anon-and-file-reclaim-statistics-in-memorystat
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1726,6 +1726,22 @@ The following nested keys are defined.
 	  pgsteal_proactive (npn)
 		Amount of reclaimed pages proactively
 
+	  pgscan_anon
+		Number of base pages scanned for reclaim from the anonymous
+		LRU. With the multi-gen LRU, counts pages isolated for reclaim.
+
+	  pgscan_file
+		Number of base pages scanned for reclaim from the file LRU.
+		With the multi-gen LRU, counts pages isolated for reclaim.
+
+	  pgsteal_anon
+		Number of base pages reclaimed from the anonymous LRU,
+		including pages demoted to another node.
+
+	  pgsteal_file
+		Number of base pages reclaimed from the file LRU,
+		including pages demoted to another node.
+
 	  pgfault (npn)
 		Total number of page faults incurred
 
@@ -1829,11 +1845,11 @@ The following nested keys are defined.
 	application performance by combining this information with the
 	application's CPU allocation.
 
-	All memory amounts are in bytes.
+	All memory amounts are in bytes. Reclaim counters are in base pages.
 
 	The output format of memory.numa_stat is::
 
-	  type N0=<bytes in node 0> N1=<bytes in node 1> ...
+	  type N0=<value for node 0> N1=<value for node 1> ...
 
 	The entries are ordered to be human readable, and new entries
 	can show up in the middle. Don't rely on items remaining in a
--- a/mm/memcontrol.c~mm-memcontrol-expose-anon-and-file-reclaim-statistics-in-memorystat
+++ a/mm/memcontrol.c
@@ -1668,10 +1668,14 @@ static const struct memory_stat memory_s
 	{ "pgsteal_direct",		PGSTEAL_DIRECT		},
 	{ "pgsteal_khugepaged",		PGSTEAL_KHUGEPAGED	},
 	{ "pgsteal_proactive",		PGSTEAL_PROACTIVE	},
+	{ "pgsteal_anon",		PGSTEAL_ANON		},
+	{ "pgsteal_file",		PGSTEAL_FILE		},
 	{ "pgscan_kswapd",		PGSCAN_KSWAPD		},
 	{ "pgscan_direct",		PGSCAN_DIRECT		},
 	{ "pgscan_khugepaged",		PGSCAN_KHUGEPAGED	},
 	{ "pgscan_proactive",		PGSCAN_PROACTIVE	},
+	{ "pgscan_anon",		PGSCAN_ANON		},
+	{ "pgscan_file",		PGSCAN_FILE		},
 	{ "pgrefill",			PGREFILL		},
 #ifdef CONFIG_NUMA_BALANCING
 	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
@@ -1720,10 +1724,14 @@ static int memcg_page_state_output_unit(
 	case PGSTEAL_DIRECT:
 	case PGSTEAL_KHUGEPAGED:
 	case PGSTEAL_PROACTIVE:
+	case PGSTEAL_ANON:
+	case PGSTEAL_FILE:
 	case PGSCAN_KSWAPD:
 	case PGSCAN_DIRECT:
 	case PGSCAN_KHUGEPAGED:
 	case PGSCAN_PROACTIVE:
+	case PGSCAN_ANON:
+	case PGSCAN_FILE:
 	case PGREFILL:
 #ifdef CONFIG_NUMA_BALANCING
 	case PGPROMOTE_SUCCESS:
_

Patches currently in -mm which might be from xueyuan.chen21@gmail.com are

mm-zsmalloc-remove-config_zsmalloc_stat.patch
mm-memcontrol-expose-anon-and-file-reclaim-statistics-in-memorystat.patch

