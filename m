From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 mm-vmalloc-track-which-page-table-levels-were-modified-fix-fix.patch added
 to -mm tree
Date: Tue, 19 May 2020 14:35:55 -0700
Message-ID: <20200519143555.eaa49931b0355b8570583cef@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
        <20200519034754.oX7A54x-e%akpm@linux-foundation.org>
        <20200519123429.GN8135@suse.de>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgESVf5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 May 2020 17:35:57 -0400
In-Reply-To: <20200519123429.GN8135@suse.de>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Joerg Roedel <jroedel@suse.de>
Cc: arnd@arndb.de, dave.hansen@linux.intel.com, hch@lst.de, hpa@zytor.com, luto@kernel.org, mhocko@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net, rostedt@goodmis.org, tglx@linutronix.de, vbabka@suse.cz, willy@infradead.org

On Tue, 19 May 2020 14:34:29 +0200 Joerg Roedel <jroedel@suse.de> wrote:

> On Mon, May 18, 2020 at 08:47:54PM -0700, Andrew Morton wrote:
> > --- a/mm/vmalloc.c~mm-vmalloc-track-which-page-table-levels-were-modified-fix-fix
> > +++ a/mm/vmalloc.c
> > @@ -310,7 +310,7 @@ int map_kernel_range_noflush(unsigned lo
> >  	} while (pgd++, addr = next, addr != end);
> >  
> >  	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
> > -		arch_sync_kernel_mappings(start, end);
> > +		arch_sync_kernel_mappings(addr, end);
> 
> I think this is wrong, as addr will be equal to end when the loop above
> finishes. Using start was right, it needs to contain the address where
> the mapping started.
> 

Um, yeah, that was me trying to get a kernel to compile at 9PM :(

--- a/mm/vmalloc.c~mm-vmalloc-track-which-page-table-levels-were-modified-fix
+++ a/mm/vmalloc.c
@@ -291,6 +291,7 @@ static int vmap_p4d_range(pgd_t *pgd, un
 int map_kernel_range_noflush(unsigned long addr, unsigned long size,
 			     pgprot_t prot, struct page **pages)
 {
+	unsigned long start = addr;
 	unsigned long end = addr + size;
 	unsigned long next;
 	pgd_t *pgd;
@@ -309,6 +310,9 @@ int map_kernel_range_noflush(unsigned lo
 			return err;
 	} while (pgd++, addr = next, addr != end);
 
+	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
+		arch_sync_kernel_mappings(start, end);
+
 	return 0;
 }
 
_
