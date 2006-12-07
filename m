From: akpm@osdl.org
Subject: - save-some-bytes-in-struct-mm_struct.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:40 -0800
Message-ID: <200612072258.kB7Mwe2i029420@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50800 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163649AbWLGW6q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@mandriva.com, mm-commits@vger.kernel.org


The patch titled
     Save some bytes in struct mm_struct
has been removed from the -mm tree.  Its filename was
     save-some-bytes-in-struct-mm_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Save some bytes in struct mm_struct
From: Arnaldo Carvalho de Melo <acme@mandriva.com>

Before:
[acme@newtoy net-2.6.20]$ pahole --cacheline 32 kernel/sched.o mm_struct

/* include2/asm/processor.h:542 */
struct mm_struct {
        struct vm_area_struct *    mmap;                 /*     0     4 */
        struct rb_root             mm_rb;                /*     4     4 */
        struct vm_area_struct *    mmap_cache;           /*     8     4 */
        long unsigned int          (*get_unmapped_area)(); /*    12     4 */
        void                       (*unmap_area)();      /*    16     4 */
        long unsigned int          mmap_base;            /*    20     4 */
        long unsigned int          task_size;            /*    24     4 */
        long unsigned int          cached_hole_size;     /*    28     4 */
        /* ---------- cacheline 1 boundary ---------- */
        long unsigned int          free_area_cache;      /*    32     4 */
        pgd_t *                    pgd;                  /*    36     4 */
        atomic_t                   mm_users;             /*    40     4 */
        atomic_t                   mm_count;             /*    44     4 */
        int                        map_count;            /*    48     4 */
        struct rw_semaphore        mmap_sem;             /*    52    64 */
        spinlock_t                 page_table_lock;      /*   116    40 */
        struct list_head           mmlist;               /*   156     8 */
        mm_counter_t               _file_rss;            /*   164     4 */
        mm_counter_t               _anon_rss;            /*   168     4 */
        long unsigned int          hiwater_rss;          /*   172     4 */
        long unsigned int          hiwater_vm;           /*   176     4 */
        long unsigned int          total_vm;             /*   180     4 */
        long unsigned int          locked_vm;            /*   184     4 */
        long unsigned int          shared_vm;            /*   188     4 */
        /* ---------- cacheline 6 boundary ---------- */
        long unsigned int          exec_vm;              /*   192     4 */
        long unsigned int          stack_vm;             /*   196     4 */
        long unsigned int          reserved_vm;          /*   200     4 */
        long unsigned int          def_flags;            /*   204     4 */
        long unsigned int          nr_ptes;              /*   208     4 */
        long unsigned int          start_code;           /*   212     4 */
        long unsigned int          end_code;             /*   216     4 */
        long unsigned int          start_data;           /*   220     4 */
        /* ---------- cacheline 7 boundary ---------- */
        long unsigned int          end_data;             /*   224     4 */
        long unsigned int          start_brk;            /*   228     4 */
        long unsigned int          brk;                  /*   232     4 */
        long unsigned int          start_stack;          /*   236     4 */
        long unsigned int          arg_start;            /*   240     4 */
        long unsigned int          arg_end;              /*   244     4 */
        long unsigned int          env_start;            /*   248     4 */
        long unsigned int          env_end;              /*   252     4 */
        /* ---------- cacheline 8 boundary ---------- */
        long unsigned int          saved_auxv[44];       /*   256   176 */
        unsigned int               dumpable:2;           /*   432     4 */
        cpumask_t                  cpu_vm_mask;          /*   436     4 */
        mm_context_t               context;              /*   440    68 */
        long unsigned int          swap_token_time;      /*   508     4 */
        /* ---------- cacheline 16 boundary ---------- */
        char                       recent_pagein;        /*   512     1 */

        /* XXX 3 bytes hole, try to pack */

        int                        core_waiters;         /*   516     4 */
        struct completion *        core_startup_done;    /*   520     4 */
        struct completion          core_done;            /*   524    52 */
        rwlock_t                   ioctx_list_lock;      /*   576    36 */
        struct kioctx *            ioctx_list;           /*   612     4 */
}; /* size: 616, sum members: 613, holes: 1, sum holes: 3, cachelines: 20,
      last cacheline: 8 bytes */

After:

[acme@newtoy net-2.6.20]$ pahole --cacheline 32 kernel/sched.o mm_struct
/* include2/asm/processor.h:542 */
struct mm_struct {
        struct vm_area_struct *    mmap;                 /*     0     4 */
        struct rb_root             mm_rb;                /*     4     4 */
        struct vm_area_struct *    mmap_cache;           /*     8     4 */
        long unsigned int          (*get_unmapped_area)(); /*    12     4 */
        void                       (*unmap_area)();      /*    16     4 */
        long unsigned int          mmap_base;            /*    20     4 */
        long unsigned int          task_size;            /*    24     4 */
        long unsigned int          cached_hole_size;     /*    28     4 */
        /* ---------- cacheline 1 boundary ---------- */
        long unsigned int          free_area_cache;      /*    32     4 */
        pgd_t *                    pgd;                  /*    36     4 */
        atomic_t                   mm_users;             /*    40     4 */
        atomic_t                   mm_count;             /*    44     4 */
        int                        map_count;            /*    48     4 */
        struct rw_semaphore        mmap_sem;             /*    52    64 */
        spinlock_t                 page_table_lock;      /*   116    40 */
        struct list_head           mmlist;               /*   156     8 */
        mm_counter_t               _file_rss;            /*   164     4 */
        mm_counter_t               _anon_rss;            /*   168     4 */
        long unsigned int          hiwater_rss;          /*   172     4 */
        long unsigned int          hiwater_vm;           /*   176     4 */
        long unsigned int          total_vm;             /*   180     4 */
        long unsigned int          locked_vm;            /*   184     4 */
        long unsigned int          shared_vm;            /*   188     4 */
        /* ---------- cacheline 6 boundary ---------- */
        long unsigned int          exec_vm;              /*   192     4 */
        long unsigned int          stack_vm;             /*   196     4 */
        long unsigned int          reserved_vm;          /*   200     4 */
        long unsigned int          def_flags;            /*   204     4 */
        long unsigned int          nr_ptes;              /*   208     4 */
        long unsigned int          start_code;           /*   212     4 */
        long unsigned int          end_code;             /*   216     4 */
        long unsigned int          start_data;           /*   220     4 */
        /* ---------- cacheline 7 boundary ---------- */
        long unsigned int          end_data;             /*   224     4 */
        long unsigned int          start_brk;            /*   228     4 */
        long unsigned int          brk;                  /*   232     4 */
        long unsigned int          start_stack;          /*   236     4 */
        long unsigned int          arg_start;            /*   240     4 */
        long unsigned int          arg_end;              /*   244     4 */
        long unsigned int          env_start;            /*   248     4 */
        long unsigned int          env_end;              /*   252     4 */
        /* ---------- cacheline 8 boundary ---------- */
        long unsigned int          saved_auxv[44];       /*   256   176 */
        cpumask_t                  cpu_vm_mask;          /*   432     4 */
        mm_context_t               context;              /*   436    68 */
        long unsigned int          swap_token_time;      /*   504     4 */
        char                       recent_pagein;        /*   508     1 */
        unsigned char              dumpable:2;           /*   509     1 */

        /* XXX 2 bytes hole, try to pack */

        int                        core_waiters;         /*   512     4 */
        struct completion *        core_startup_done;    /*   516     4 */
        struct completion          core_done;            /*   520    52 */
        rwlock_t                   ioctx_list_lock;      /*   572    36 */
        struct kioctx *            ioctx_list;           /*   608     4 */
}; /* size: 612, sum members: 610, holes: 1, sum holes: 2, cachelines: 20,
      last cacheline: 4 bytes */

[acme@newtoy net-2.6.20]$ codiff -V /tmp/sched.o.before kernel/sched.o
/pub/scm/linux/kernel/git/acme/net-2.6.20/kernel/sched.c:
  struct mm_struct |   -4
    dumpable:2;
     from: unsigned int          /*   432(30)    4(2) */
     to:   unsigned char         /*   509(6)     1(2) */
< SNIP other offset changes >
 1 struct changed
[acme@newtoy net-2.6.20]$

I'm not aware of any problem about using 2 byte wide bitfields where
previously a 4 byte wide one was, holler if there is any, I wouldn't be
surprised, bitfields are things from hell.

For the curious, 432(30) means: at offset 432 from the struct start, at
offset 30 in the bitfield (yeah, it comes backwards, hellish, huh?) ditto
for 509(6), while 4(2) and 1(2) means "struct field size(bitfield size)".

Now we have a 2 bytes hole and are using only 4 bytes of the last 32
bytes cacheline, any takers? :-)

Signed-off-by: Arnaldo Carvalho de Melo <acme@mandriva.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sched.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/sched.h~save-some-bytes-in-struct-mm_struct include/linux/sched.h
--- a/include/linux/sched.h~save-some-bytes-in-struct-mm_struct
+++ a/include/linux/sched.h
@@ -338,7 +338,6 @@ struct mm_struct {
 
 	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
-	unsigned dumpable:2;
 	cpumask_t cpu_vm_mask;
 
 	/* Architecture-specific MM context */
@@ -355,6 +354,8 @@ struct mm_struct {
 	unsigned int token_priority;
 	unsigned int last_interval;
 
+	unsigned char dumpable:2;
+
 	/* coredumping support */
 	int core_waiters;
 	struct completion *core_startup_done, core_done;
_

Patches currently in -mm which might be from acme@mandriva.com are

origin.patch

