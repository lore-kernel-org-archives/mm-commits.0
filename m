From: akpm@linux-foundation.org
Subject: [merged] scripts-tagssh-increase-identifier-list.patch removed
 from -mm tree
Date: Thu, 31 Oct 2013 10:59:51 -0700
Message-ID: <52729a97.A5KCZrVC0bAf6OvW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab3JaR7w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 13:59:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mmarek@suse.cz, tkhai@yandex.ru

Subject: [merged] scripts-tagssh-increase-identifier-list.patch removed from -mm tree
To: tkhai@yandex.ru,mmarek@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 10:59:51 -0700


The patch titled
     Subject: scripts/tags.sh: Increase identifier list
has been removed from the -mm tree.  Its filename was
     scripts-tagssh-increase-identifier-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kirill Tkhai <tkhai@yandex.ru>
Subject: scripts/tags.sh: Increase identifier list

Add		__maybe_unused
		__always_unused
		__cacheline_aligned
		__cacheline_aligned_in_smp
		ACPI_EXPORT_SYMBOL
to the list.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/tags.sh~scripts-tagssh-increase-identifier-list scripts/tags.sh
--- a/scripts/tags.sh~scripts-tagssh-increase-identifier-list
+++ a/scripts/tags.sh
@@ -151,13 +151,14 @@ exuberant()
 	all_target_sources | xargs $1 -a                        \
 	-I __initdata,__exitdata,__initconst,__devinitdata	\
 	-I __devinitconst,__cpuinitdata,__initdata_memblock	\
-	-I __refdata,__attribute				\
+	-I __refdata,__attribute,__maybe_unused,__always_unused \
 	-I __acquires,__releases,__deprecated			\
 	-I __read_mostly,__aligned,____cacheline_aligned        \
 	-I ____cacheline_aligned_in_smp                         \
+	-I __cacheline_aligned,__cacheline_aligned_in_smp	\
 	-I ____cacheline_internodealigned_in_smp                \
 	-I __used,__packed,__packed2__,__must_check,__must_hold	\
-	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
+	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL,ACPI_EXPORT_SYMBOL   \
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
 	-I static,const						\
 	--extra=+f --c-kinds=+px                                \
_

Patches currently in -mm which might be from tkhai@yandex.ru are

linux-next.patch

