Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1E3C07E96
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 05:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6073061CE3
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 05:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhGHFYt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Jul 2021 01:24:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43934 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229579AbhGHFYs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2021 01:24:48 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16859ArY036164;
        Thu, 8 Jul 2021 01:21:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=cyqumZKVbW73SocqcpWx7rRacWP2TymwwmZ//i5dxBI=;
 b=YpPh1i1SVemRDrEoasUOH+SYWBudlLaC/kbx9Rg2LKEHiywVEKrZvfyodyx1DLCfqrM0
 T7lkqUDa0YvYjQH5zNX1NPT3+BseD4zQp8gpR2so/0nHEC4GBU6phtRX3yXNVm4yWdTe
 1w3dOgVWCotq2UPRKARIQj+tCD/3W3jJGH+3AfUeBx1zYEaJTIb7Sf11DUMKdW/v/AEw
 RBFtNWoz/HDtt3ixNTDG4/zCi38qkNeSC+8PqB+n5d5t97C9/+1mHsCVitNYOhQJPLUD
 lpDmxvksBGWZZMCgPKsAbmmiRY4oYC1w8ZQ5c90Ky/YkXLlFr2NqLYvENfESN8wJfArL dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39m5q39fk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Jul 2021 01:21:13 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1685I75e081304;
        Thu, 8 Jul 2021 01:21:12 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39m5q39fh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Jul 2021 01:21:12 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1685Cw3N004710;
        Thu, 8 Jul 2021 05:21:09 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 39jfh8t15v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Jul 2021 05:21:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1685L6Ho33751314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Jul 2021 05:21:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF0EBAE056;
        Thu,  8 Jul 2021 05:21:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A307CAE059;
        Thu,  8 Jul 2021 05:21:03 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.167.250])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  8 Jul 2021 05:21:03 +0000 (GMT)
Date:   Thu, 8 Jul 2021 08:21:01 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        Roman Gushchin <guro@fb.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        Peter Anvin <hpa@zytor.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Linux-MM <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>, mm-commits@vger.kernel.org,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Shakeel Butt <shakeelb@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [patch 11/54] mm: introduce memfd_secret system call to create
 "secret" memory areas
Message-ID: <YOaLPVFwQDBMcTMD@linux.ibm.com>
References: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
 <20210708010803.i6RiDHM3L%akpm@linux-foundation.org>
 <CAHk-=whWxnQW=2Rx8uj01nGMGK3oOS9fJZCe6atVP7and5DkWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whWxnQW=2Rx8uj01nGMGK3oOS9fJZCe6atVP7and5DkWg@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s22ca7QPPvxwf4aez1zgfUyXFgCvx5Hz
X-Proofpoint-GUID: hPIYXA5M6r6OIKk-RzO8SEN91Su0J4Fc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-08_01:2021-07-06,2021-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 bulkscore=0 clxscore=1011 impostorscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 mlxlogscore=884 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107080025
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jul 07, 2021 at 08:13:10PM -0700, Linus Torvalds wrote:
> On Wed, Jul 7, 2021 at 6:08 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > Subject: mm: introduce memfd_secret system call to create "secret" memory areas
> >
> > Introduce "memfd_secret" system call with the ability to create memory
> > areas visible only in the context of the owning process and not mapped not
> > only to other processes but in the kernel page tables as well.
> 
> Am I missing something?
> 
> From what I can't tell, this must not be enabled for regular users,
> because the secret mapping is effectively mlock'ed into the address
> space.
> 
> But there does not seem to be any permission checks or any limits, so
> this looks like a trivial way for a bad user to force the kernel to
> run out of memory.

This feature is off by default and should be explicitly enabled by a system
administrator. 
When it is enabled, a user cannot exceed RLIMIT_MEMLOCK.
 
-- 
Sincerely yours,
Mike.
