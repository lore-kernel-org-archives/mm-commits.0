From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + provide-acpi_check_mem_region-checkpatch-fixes.patch added to
 -mm tree
Date: Thu, 25 Oct 2007 13:16:46 -0700
Message-ID: <20071025131646.75f01aa4.akpm@linux-foundation.org>
References: <200710250351.l9P3pX1G030384@imap1.linux-foundation.org>
	<20071025154104.33b7b8e1@hyperion.delvare>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36261 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750701AbXJYURP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 16:17:15 -0400
In-Reply-To: <20071025154104.33b7b8e1@hyperion.delvare>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Jean Delvare <khali@linux-fr.org>
Cc: mm-commits@vger.kernel.org, lenb@kernel.org, mhoffman@lightlink.com, trenn@suse.de

On Thu, 25 Oct 2007 15:41:04 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> Hi Andrew,
> 
> On Wed, 24 Oct 2007 20:51:33 -0700, akpm@linux-foundation.org wrote:
> > 
> > The patch titled
> >      provide-acpi_check_mem_region-checkpatch-fixes
> > has been added to the -mm tree.  Its filename is
> >      provide-acpi_check_mem_region-checkpatch-fixes.patch
> > 
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > 
> > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> > out what to do about this
> > 
> > ------------------------------------------------------
> > Subject: provide-acpi_check_mem_region-checkpatch-fixes
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > WARNING: printk() should include KERN_ facility level
> > #133: FILE: drivers/acpi/osl.c:1133:
> > +			printk("%sACPI: %s resource %s [0x%llx-0x%llx]"
> > 
> > total: 0 errors, 1 warnings, 224 lines checked
> > Your patch has style problems, please review.  If any of these errors
> > are false positives report them to the maintainer, see
> > CHECKPATCH in MAINTAINERS.
> > 
> > Please run checkpatch prior to sending patches
> 
> Except that checkpatch is wrong in this case, the original patch was
> correct and your add-on broke it. The log level is %s because it
> depends on the value of acpi_enforce_resources.
> 
> I admit it's a bit tricky and I'm not surprised checkpatch got
> confused. It's probably rare enough that it's not worth fixing the
> script.

OK.  We now have KERN_CONT, which is the empty string.  It could have been
used here as a way of keeping checkpatch happy and to tell readers "yes,
this printk's faciliy level has been thought about".

KERN_CONT is also useful for things like ata_dev_printk() which _require_ a
facility level.
