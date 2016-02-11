From: akpm@linux-foundation.org
Subject: + mm-tracing-refresh-__def_vmaflag_names.patch added to -mm tree
Date: Thu, 11 Feb 2016 13:53:34 -0800
Message-ID: <56bd02de.6PqfzttzJiPo1heK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbcBKVxf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Feb 2016 16:53:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, tracing: refresh __def_vmaflag_names
has been added to the -mm tree.  Its filename is
     mm-tracing-refresh-__def_vmaflag_names.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-tracing-refresh-__def_vmaflag_names.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-tracing-refresh-__def_vmaflag_names.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, tracing: refresh __def_vmaflag_names

Get list of VMA flags up-to-date and sort it to match VM_* definition
order.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmflags.h |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN include/trace/events/mmflags.h~mm-tracing-refresh-__def_vmaflag_names include/trace/events/mmflags.h
--- a/include/trace/events/mmflags.h~mm-tracing-refresh-__def_vmaflag_names
+++ a/include/trace/events/mmflags.h
@@ -111,15 +111,21 @@ IF_HAVE_PG_IDLE(PG_idle,		"idle"		)
 	) : "none"
 
 #if defined(CONFIG_X86)
-#define __VM_ARCH_SPECIFIC {VM_PAT,     "pat"           }
+#define __VM_ARCH_SPECIFIC_1 {VM_PAT,     "pat"           }
 #elif defined(CONFIG_PPC)
-#define __VM_ARCH_SPECIFIC {VM_SAO,     "sao"           }
+#define __VM_ARCH_SPECIFIC_1 {VM_SAO,     "sao"           }
 #elif defined(CONFIG_PARISC) || defined(CONFIG_METAG) || defined(CONFIG_IA64)
-#define __VM_ARCH_SPECIFIC {VM_GROWSUP,	"growsup"	}
+#define __VM_ARCH_SPECIFIC_1 {VM_GROWSUP,	"growsup"	}
 #elif !defined(CONFIG_MMU)
-#define __VM_ARCH_SPECIFIC {VM_MAPPED_COPY,"mappedcopy"	}
+#define __VM_ARCH_SPECIFIC_1 {VM_MAPPED_COPY,"mappedcopy"	}
 #else
-#define __VM_ARCH_SPECIFIC {VM_ARCH_1,	"arch_1"	}
+#define __VM_ARCH_SPECIFIC_1 {VM_ARCH_1,	"arch_1"	}
+#endif
+
+#if defined(CONFIG_X86)
+#define __VM_ARCH_SPECIFIC_2 {VM_MPX,		"mpx"		}
+#else
+#define __VM_ARCH_SPECIFIC_2 {VM_ARCH_2,	"arch_2"	}
 #endif
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
@@ -138,19 +144,22 @@ IF_HAVE_PG_IDLE(PG_idle,		"idle"		)
 	{VM_MAYEXEC,			"mayexec"	},		\
 	{VM_MAYSHARE,			"mayshare"	},		\
 	{VM_GROWSDOWN,			"growsdown"	},		\
+	{VM_UFFD_MISSING,		"uffd_missing"	},		\
 	{VM_PFNMAP,			"pfnmap"	},		\
 	{VM_DENYWRITE,			"denywrite"	},		\
-	{VM_LOCKONFAULT,		"lockonfault"	},		\
+	{VM_UFFD_WP,			"uffd_wp"	},		\
 	{VM_LOCKED,			"locked"	},		\
 	{VM_IO,				"io"		},		\
 	{VM_SEQ_READ,			"seqread"	},		\
 	{VM_RAND_READ,			"randread"	},		\
 	{VM_DONTCOPY,			"dontcopy"	},		\
 	{VM_DONTEXPAND,			"dontexpand"	},		\
+	{VM_LOCKONFAULT,		"lockonfault"	},		\
 	{VM_ACCOUNT,			"account"	},		\
 	{VM_NORESERVE,			"noreserve"	},		\
 	{VM_HUGETLB,			"hugetlb"	},		\
-	__VM_ARCH_SPECIFIC				,		\
+	__VM_ARCH_SPECIFIC_1				,		\
+	__VM_ARCH_SPECIFIC_2				,		\
 	{VM_DONTDUMP,			"dontdump"	},		\
 IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
 	{VM_MIXEDMAP,			"mixedmap"	},		\
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-dax-check-for-pmd_none-after-split_huge_pmd.patch
thp-dax-do-not-try-to-withdraw-pgtable-from-non-anon-vma.patch
ipc-shm-handle-removed-segments-gracefully-in-shm_mmap.patch
thp-cleanup-split_huge_page.patch
thp-vmstats-count-deferred-split-events.patch
mm-tracing-refresh-__def_vmaflag_names.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

