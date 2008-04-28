From: akpm@linux-foundation.org
Subject: + reapply-sched-cpuset-customize-sched-domains-core-bits-fix.patch added to -mm tree
Date: Sun, 27 Apr 2008 23:18:22 -0700
Message-ID: <200804280618.m3S6ILfS011292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbYD1GTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:19:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: seto.hidetoshi@jp.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mingo@elte.hu, pj@sgi.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     reapply-sched-cpuset-customize-sched-domains-core-bits fix
has been added to the -mm tree.  Its filename is
     reapply-sched-cpuset-customize-sched-domains-core-bits-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reapply-sched-cpuset-customize-sched-domains-core-bits fix
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Menage <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff -puN kernel/cpuset.c~reapply-sched-cpuset-customize-sched-domains-core-bits-fix kernel/cpuset.c
--- a/kernel/cpuset.c~reapply-sched-cpuset-customize-sched-domains-core-bits-fix
+++ a/kernel/cpuset.c
@@ -129,7 +129,6 @@ typedef enum {
 	CS_MEM_EXCLUSIVE,
 	CS_MEMORY_MIGRATE,
 	CS_SCHED_LOAD_BALANCE,
-	CS_SCHED_RELAX_DOMAIN_LEVEL,
 	CS_SPREAD_PAGE,
 	CS_SPREAD_SLAB,
 } cpuset_flagbits_t;
@@ -150,11 +149,6 @@ static inline int is_sched_load_balance(
 	return test_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 }
 
-static inline int is_sched_relax_domain_level(const struct cpuset *cs)
-{
-	return test_bit(CS_SCHED_RELAX_DOMAIN_LEVEL, &cs->flags);
-}
-
 static inline int is_memory_migrate(const struct cpuset *cs)
 {
 	return test_bit(CS_MEMORY_MIGRATE, &cs->flags);
@@ -1029,6 +1023,21 @@ int current_cpuset_is_being_rebound(void
 	return task_cs(current) == cpuset_being_rebound;
 }
 
+static int update_relax_domain_level(struct cpuset *cs, char *buf)
+{
+	int val = simple_strtol(buf, NULL, 10);
+
+	if (val < 0)
+		val = -1;
+
+	if (val != cs->relax_domain_level) {
+		cs->relax_domain_level = val;
+		rebuild_sched_domains();
+	}
+
+	return 0;
+}
+
 /*
  * update_flag - read a 0 or a 1 in a file and update associated flag
  * bit:	the bit to update (CS_CPU_EXCLUSIVE, CS_MEM_EXCLUSIVE,
@@ -1264,6 +1273,9 @@ static ssize_t cpuset_common_file_write(
 	case FILE_MEMLIST:
 		retval = update_nodemask(cs, buffer);
 		break;
+	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
+		retval = update_relax_domain_level(cs, buffer);
+		break;
 	default:
 		retval = -EINVAL;
 		goto out2;
@@ -1301,9 +1313,6 @@ static int cpuset_write_u64(struct cgrou
 	case FILE_SCHED_LOAD_BALANCE:
 		retval = update_flag(CS_SCHED_LOAD_BALANCE, cs, val);
 		break;
-	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
-		retval = update_flag(CS_SCHED_RELAX_DOMAIN_LEVEL, cs, val);
-		break;
 	case FILE_MEMORY_MIGRATE:
 		retval = update_flag(CS_MEMORY_MIGRATE, cs, val);
 		break;
@@ -1387,6 +1396,9 @@ static ssize_t cpuset_common_file_read(s
 	case FILE_MEMLIST:
 		s += cpuset_sprintf_memlist(s, cs);
 		break;
+	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
+		s += sprintf(s, "%d", cs->relax_domain_level);
+		break;
 	default:
 		retval = -EINVAL;
 		goto out;
@@ -1410,8 +1422,6 @@ static u64 cpuset_read_u64(struct cgroup
 		return is_mem_exclusive(cs);
 	case FILE_SCHED_LOAD_BALANCE:
 		return is_sched_load_balance(cs);
-	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
-		return is_sched_relax_domain_level(cs);
 	case FILE_MEMORY_MIGRATE:
 		return is_memory_migrate(cs);
 	case FILE_MEMORY_PRESSURE_ENABLED:
_

Patches currently in -mm which might be from seto.hidetoshi@jp.fujitsu.com are

origin.patch
revert-part-of-sched-cpuset-customize-sched-domains-core.patch
reapply-sched-cpuset-customize-sched-domains-core-bits.patch
reapply-sched-cpuset-customize-sched-domains-core-bits-fix.patch

