From: akpm@linux-foundation.org
Subject: [merged] mm-tracing-refresh-__def_vmaflag_names.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:39:08 -0700
Message-ID: <56f03fcc.gsa2QYzs4f9Wdutm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbcCUT42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, tracing: refresh __def_vmaflag_names
has been removed from the -mm tree.  Its filename was
     mm-tracing-refresh-__def_vmaflag_names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, tracing: refresh __def_vmaflag_names

Get list of VMA flags up-to-date and sort it to match VM_* definition
order.

[vbabka@suse.cz: add a note above vmaflag definitions to update the names when changing]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h             |    1 +
 include/trace/events/mmflags.h |   23 ++++++++++++++++-------
 2 files changed, 17 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-tracing-refresh-__def_vmaflag_names include/linux/mm.h
--- a/include/linux/mm.h~mm-tracing-refresh-__def_vmaflag_names
+++ a/include/linux/mm.h
@@ -143,6 +143,7 @@ extern unsigned int kobjsize(const void
 
 /*
  * vm_flags in vm_area_struct, see mm_types.h.
+ * When changing, update also include/trace/events/mmflags.h
  */
 #define VM_NONE		0x00000000
 
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

mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

