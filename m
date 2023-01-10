Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CCCC54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 11:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjAJLBX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 06:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbjAJLBL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 06:01:11 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A34E52
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 03:01:04 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 57876604F1;
        Tue, 10 Jan 2023 12:01:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673348461; bh=sr3BWTs+8ftDVgFrsof/jeU+kn0GfcVYSd/BQMaVdvE=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=sHkTeATpGkbdMKUcLt3Iv/nPtTiUk9G/SfeXc0H3oluLujQBbyhaIFPWc6m5lzuOd
         k+ASsx1SwZ7409VSPnbAvl5dzrFOEJtNYU7u/QyuWgMq9ik1jRCDs/WKwpIiiRcO83
         9oed1vgWXIaF88kM2HfVE0zhvVq8UKr/UjrKRRWxEa23DmwLVH1nDi/HwbYz3d5mz7
         dSfFrY+qSf7q6uuFWiaSZyPsX+KuZgF2UjrNvu8pWAND5ukqYY/cXIn7ny1fF3cDTG
         8n2dUNHVvIsJnDqTTP7iP1TOT66sxe7CwP64fZ0VAg022742iu6AIFCCK8NiuOQEWk
         q+FVrnECpFX0w==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZbBWr_zX-If0; Tue, 10 Jan 2023 12:00:58 +0100 (CET)
Received: from [193.198.186.200] (pc-mtodorov.slava.alu.hr [193.198.186.200])
        by domac.alu.hr (Postfix) with ESMTPSA id 79F4B604F0;
        Tue, 10 Jan 2023 12:00:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673348458; bh=sr3BWTs+8ftDVgFrsof/jeU+kn0GfcVYSd/BQMaVdvE=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=aVn5mlxTNuLtOx89hsTHQpdkYnLywTIfYtB8zHoaUrjY0/CspODfibBK0A3UVaMsN
         GPinKc6MRAJ9rGcEo925gHG08jjE9//+6gEs/l4Jw+BoBcvvCXrJ5vYwMWuS0bqHxb
         HiO/Ul4k63nYZJmFr/9zwMPn+RPnMn/1Bmp6WFo66CSjFRjsGZWJGtLPun3Ev+j7y8
         nuWO1G+NTOuEPAX7DGEbCYus7xd2b54r/7NC+k25gkiXbjpBfDWt7ifKTpzZSyoRMa
         7oaiYbFv90vL+EIH5kFRD81X3ptV72BAKrGC9YSwVrPJ1arQbTOZBfEW3r5oh2H8kz
         6T+PCK6y+7dhQ==
Message-ID: <cb32e13b-2edd-8a4d-dfc1-779d03a1ff67@alu.unizg.hr>
Date:   Tue, 10 Jan 2023 12:00:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: +
 selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch added to
 mm-unstable branch
Content-Language: en-US, hr
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, shuah@kernel.org, david@redhat.com
References: <20230109233601.C4082C433EF@smtp.kernel.org>
From:   Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <20230109233601.C4082C433EF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi,

On 1/10/23 00:36, Andrew Morton wrote:
> The patch titled
>       Subject: selftests/mm: define MADV_PAGEOUT to fix compilation issues
> has been added to the -mm mm-unstable branch.  Its filename is
>       selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
> 
> This patch will later appear in the mm-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: David Hildenbrand <david@redhat.com>
> Subject: selftests/mm: define MADV_PAGEOUT to fix compilation issues
> Date: Mon, 9 Jan 2023 18:12:55 +0100
> 
> If MADV_PAGEOUT is not defined (e.g., on AlmaLinux 8), compilation will
> fail.  Let's fix that like khugepaged.c does by conditionally defining
> MADV_PAGEOUT.
> 
> Link: https://lkml.kernel.org/r/20230109171255.488749-1-david@redhat.com
> Fixes: 69c66add5663 ("selftests/vm: anon_cow: test COW handling of anonymous memory")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> Cc: Shuah Khan <shuah@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   tools/testing/selftests/mm/cow.c |    3 +++
>   1 file changed, 3 insertions(+)
> 
> --- a/tools/testing/selftests/mm/cow.c~selftests-mm-define-madv_pageout-to-fix-compilation-issues
> +++ a/tools/testing/selftests/mm/cow.c
> @@ -30,6 +30,9 @@
>   #include "../kselftest.h"
>   #include "vm_util.h"
>   
> +#ifndef MADV_PAGEOUT
> +#define MADV_PAGEOUT 21
> +#endif
>   #ifndef MADV_COLLAPSE
>   #define MADV_COLLAPSE 25
>   #endif
> _
> 
> Patches currently in -mm which might be from david@redhat.com are
> 
> mm-hugetlb-fix-pte-marker-handling-in-hugetlb_change_protection.patch
> mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch
> mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
> mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
> mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch
> mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
> mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch
> selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch
> mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping.patch
> mm-nommu-dont-use-vm_mayshare-for-map_private-mappings.patch
> drivers-misc-open-dice-dont-touch-vm_mayshare.patch
> selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
Please consider alternative patch instead. I am submitting it for a
review.

It would give the referential integrity to the source of the selftest/vm
subtree.

#ifdef ... #endif encapsulation around `#define __USE_GNU` eliminates a
warning.

RATIONALE:

Though it is ulikely that the values of MADV_PAGEOUT,
MADV_POPULATE_READ and MADV_COLLAPSE will change, the source integrity
would benefit from having it changed in only one place,
.../usr/include/asm-generic/mman-common.h, included by

#include <linux/mman.h>

rather than in three places: mman-common.h, vm/cow.c and vm/khugepaged.c.

This can potentially lead to hard-to-find bugs, as three sources may
disagree about the value of MADV_PAGEOUT, MADV_POPULATE_READ and
MADV_COLLAPSE macro defines.

Thank you very much for your time and consideration.

Regards,
Mirsad

----------------------------------------------------------------------------------------------------------
  tools/testing/selftests/vm/cow.c             |  1 +
  tools/testing/selftests/vm/hugetlb-madvise.c |  2 ++
  tools/testing/selftests/vm/khugepaged.c      | 11 +----------
  3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/vm/cow.c 
b/tools/testing/selftests/vm/cow.c
index 26f6ea3079e2..7707b97e3ff4 100644
--- a/tools/testing/selftests/vm/cow.c
+++ b/tools/testing/selftests/vm/cow.c
@@ -20,6 +20,7 @@
  #include <sys/ioctl.h>
  #include <sys/wait.h>
  #include <linux/memfd.h>
+#include <linux/mman.h>

  #include "local_config.h"
  #ifdef LOCAL_CONFIG_HAVE_LIBURING
diff --git a/tools/testing/selftests/vm/hugetlb-madvise.c 
b/tools/testing/selftests/vm/hugetlb-madvise.c
index a634f47d1e56..163dafe759d4 100644
--- a/tools/testing/selftests/vm/hugetlb-madvise.c
+++ b/tools/testing/selftests/vm/hugetlb-madvise.c
@@ -17,7 +17,9 @@
  #include <stdio.h>
  #include <unistd.h>
  #include <sys/mman.h>
+#ifndef __USE_GNU
  #define __USE_GNU
+#endif
  #include <fcntl.h>

  #define MIN_FREE_PAGES 20
diff --git a/tools/testing/selftests/vm/khugepaged.c 
b/tools/testing/selftests/vm/khugepaged.c
index 64126c8cd561..6302de1ab0d0 100644
--- a/tools/testing/selftests/vm/khugepaged.c
+++ b/tools/testing/selftests/vm/khugepaged.c
@@ -19,19 +19,10 @@
  #include <sys/vfs.h>

  #include "linux/magic.h"
+#include "linux/mman.h"

  #include "vm_util.h"

-#ifndef MADV_PAGEOUT
-#define MADV_PAGEOUT 21
-#endif
-#ifndef MADV_POPULATE_READ
-#define MADV_POPULATE_READ 22
-#endif
-#ifndef MADV_COLLAPSE
-#define MADV_COLLAPSE 25
-#endif
-
  #define BASE_ADDR ((void *)(1UL << 30))
  static unsigned long hpage_pmd_size;
  static unsigned long page_size;

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
