Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A63D4C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 15:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BAE8613B5
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 15:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhGIPsl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 11:48:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232269AbhGIPsl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2021 11:48:41 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 169FYZ5C048035;
        Fri, 9 Jul 2021 11:44:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=JWzobe3s7Lk/N2OAyaX6fbtpEtO9iupxqeMPUTuYDIk=;
 b=aOENdzL1Oi8ufPWflQlB+/euazqhl0mFQoVImfdVWZAa/6FNFEfcnxp6Erq774uGov4d
 9FrRoGsRk2iVAF2u7w2GAJUqjgbPV/Gp55Uv6HPRIe+k1wja8kYfG8QsjM4HwpzQkHsU
 SLvoZ2h+fRatDUpBblhwPkER4bmErB1dlkJVYCsqf0WsvflnJeM4KJictIOJ1Z2ip4iO
 2qsDdbYHlavBLhGtENZFPttfTk3Wx9stYBjMS9oP2jOJGm/BPiY4hazTIclIdLJ0Euvo
 nCDyGwtjWU5Z/zqUrHFgyFKH26YBlt034S1WkKgkKDIoFgxx38sWA8dSVHtSaHnJxarp zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39nwfd8svn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Jul 2021 11:44:19 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 169FZCbG049415;
        Fri, 9 Jul 2021 11:44:19 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39nwfd8suu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Jul 2021 11:44:18 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 169FdcEJ007433;
        Fri, 9 Jul 2021 15:44:16 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 39jfh89fn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Jul 2021 15:44:16 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 169FiD8k27525624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Jul 2021 15:44:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38878AE05F;
        Fri,  9 Jul 2021 15:44:13 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18B06AE057;
        Fri,  9 Jul 2021 15:44:10 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.167.250])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  9 Jul 2021 15:44:09 +0000 (GMT)
Date:   Fri, 9 Jul 2021 18:44:08 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Hagen Paul Pfeifer <hagen@jauu.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        Roman Gushchin <guro@fb.com>, Peter Anvin <hpa@zytor.com>,
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
Message-ID: <YOhuyLlRhGXMo96b@linux.ibm.com>
References: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
 <20210708010803.i6RiDHM3L%akpm@linux-foundation.org>
 <CAHk-=whWxnQW=2Rx8uj01nGMGK3oOS9fJZCe6atVP7and5DkWg@mail.gmail.com>
 <YOaLPVFwQDBMcTMD@linux.ibm.com>
 <CAHk-=whEZT3f+-oDZ4kdz31GxxJ9QD_P1XrMBnM8DamdF9QHDg@mail.gmail.com>
 <YOdcY5SYIjPDO7nG@laniakea>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOdcY5SYIjPDO7nG@laniakea>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FNQLtfKVjsyNaRGqMaDVvvP8IGERTKXs
X-Proofpoint-ORIG-GUID: 6hkNgjOYDCt9UacnGSKJs57-OuE8Nasu
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-09_09:2021-07-09,2021-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107090078
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hello Hagen,

On Thu, Jul 08, 2021 at 10:13:23PM +0200, Hagen Paul Pfeifer wrote:
> * Linus Torvalds | 2021-07-08 11:38:51 [-0700]:
> 
> Hello Mike, Linus
> 
> >> This feature is off by default and should be explicitly enabled by a system
> >> administrator.
> >>
> >> When it is enabled, a user cannot exceed RLIMIT_MEMLOCK.
> 
> Just an idea/proposal:
> 
> this feature could be granted based on capabilities (new or existing one,
> hopefully not CAP_SYS_ADMIN). Capabilities would provide a very convenient,
> simple and fine granular way to use this, at least from a user perspective. Or
> do I forget something Mike? 

Our preference is to have secretmem available to everybody.

As James nicely put it [1]:

	I don't think dividing the world into people who can and can't use
	secret memory would be useful since the design is to be usable for
	anyone who might have a secret to keep; it would become like the
	kvm group permissions: something which is theoretically an access
	control but which in practise is given to everyone on the system.
 

[1] https://lore.kernel.org/lkml/73738cda43236b5ac2714e228af362b67a712f5d.camel@linux.ibm.com/

-- 
Sincerely yours,
Mike.
