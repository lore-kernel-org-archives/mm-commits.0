From: akpm@linux-foundation.org
Subject: - oprofile-oops-when-profile_pc-return-0lu.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:08:34 -0800
Message-ID: <200711152108.lAFL8YmO015370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37240 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757732AbXKOVI7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:08:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phil.el@wanadoo.fr, safari-kernel@safari.iki.fi, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     oProfile: oops when profile_pc() returns ~0LU
has been removed from the -mm tree.  Its filename was
     oprofile-oops-when-profile_pc-return-0lu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oProfile: oops when profile_pc() returns ~0LU
From: Philippe Elie <phil.el@wanadoo.fr>

Instruction pointer returned by profile_pc() can be a random value.  This
break the assumption than we can safely set struct op_sample.eip field to a
magic value to signal to the per-cpu buffer reader side special event like
task switch ending up in a segfault in get_task_mm() when profile_pc()
return ~0UL.  Fixed by sanitizing the sampled eip and reject/log invalid
eip.

Problem reported by Sami Farin, patch tested by him.

Signed-off-by: Philippe Elie <phil.el@wanadoo.fr>
Tested-by: Sami Farin <safari-kernel@safari.iki.fi>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/oprofile/cpu_buffer.c     |    7 +++++++
 drivers/oprofile/cpu_buffer.h     |    1 +
 drivers/oprofile/oprofile_stats.c |    4 ++++
 3 files changed, 12 insertions(+)

diff -puN drivers/oprofile/cpu_buffer.c~oprofile-oops-when-profile_pc-return-0lu drivers/oprofile/cpu_buffer.c
--- a/drivers/oprofile/cpu_buffer.c~oprofile-oops-when-profile_pc-return-0lu
+++ a/drivers/oprofile/cpu_buffer.c
@@ -64,6 +64,8 @@ int alloc_cpu_buffers(void)
 		b->head_pos = 0;
 		b->sample_received = 0;
 		b->sample_lost_overflow = 0;
+		b->backtrace_aborted = 0;
+		b->sample_invalid_eip = 0;
 		b->cpu = i;
 		INIT_DELAYED_WORK(&b->work, wq_sync_buffer);
 	}
@@ -175,6 +177,11 @@ static int log_sample(struct oprofile_cp
 
 	cpu_buf->sample_received++;
 
+	if (pc == ESCAPE_CODE) {
+		cpu_buf->sample_invalid_eip++;
+		return 0;
+	}
+
 	if (nr_available_slots(cpu_buf) < 3) {
 		cpu_buf->sample_lost_overflow++;
 		return 0;
diff -puN drivers/oprofile/cpu_buffer.h~oprofile-oops-when-profile_pc-return-0lu drivers/oprofile/cpu_buffer.h
--- a/drivers/oprofile/cpu_buffer.h~oprofile-oops-when-profile_pc-return-0lu
+++ a/drivers/oprofile/cpu_buffer.h
@@ -42,6 +42,7 @@ struct oprofile_cpu_buffer {
 	unsigned long sample_received;
 	unsigned long sample_lost_overflow;
 	unsigned long backtrace_aborted;
+	unsigned long sample_invalid_eip;
 	int cpu;
 	struct delayed_work work;
 } ____cacheline_aligned;
diff -puN drivers/oprofile/oprofile_stats.c~oprofile-oops-when-profile_pc-return-0lu drivers/oprofile/oprofile_stats.c
--- a/drivers/oprofile/oprofile_stats.c~oprofile-oops-when-profile_pc-return-0lu
+++ a/drivers/oprofile/oprofile_stats.c
@@ -26,6 +26,8 @@ void oprofile_reset_stats(void)
 		cpu_buf = &cpu_buffer[i]; 
 		cpu_buf->sample_received = 0;
 		cpu_buf->sample_lost_overflow = 0;
+		cpu_buf->backtrace_aborted = 0;
+		cpu_buf->sample_invalid_eip = 0;
 	}
  
 	atomic_set(&oprofile_stats.sample_lost_no_mm, 0);
@@ -61,6 +63,8 @@ void oprofile_create_stats_files(struct 
 			&cpu_buf->sample_lost_overflow);
 		oprofilefs_create_ro_ulong(sb, cpudir, "backtrace_aborted",
 			&cpu_buf->backtrace_aborted);
+		oprofilefs_create_ro_ulong(sb, cpudir, "sample_invalid_eip",
+			&cpu_buf->sample_invalid_eip);
 	}
  
 	oprofilefs_create_ro_atomic(sb, dir, "sample_lost_no_mm",
_

Patches currently in -mm which might be from phil.el@wanadoo.fr are

origin.patch
