Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E85C001B0
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 18:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjGMSRa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 14:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjGMSR3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 14:17:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808C6273F;
        Thu, 13 Jul 2023 11:17:28 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DHidWC030117;
        Thu, 13 Jul 2023 18:17:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=seRIxoKQnNb8qjCOXBTz1wdkU56W4sjWhqbiAdO9q/s=;
 b=JlxVAepIaxp9iMv4sNl5MX6Yoh7my4ChfL4/+9LdnnmYScU3MxT2nNGucZE2fcSAJPP1
 65BATBIwvxVBa6WlTQGEJXkJAoPnP1RlbclcDdWI0O/YdE+XjdaSSEBIWrcZIgujqK/P
 Rsq+h3q3tqXGGGW8ayajFN7HW9tolW+qGQI8Q+uqrQx8F1EF+xjcluSSai1y0bcOdpCS
 oOYDXs5T8nreLbYMsDC5mkJB/CdYvPUJcab1gYJF20cFIuLiUvX6RPxn0UaKCzLCbo4s
 tsc0MekYch+cID5w2FqJMMXOcmEUgozS2n3hKlv5SyRb9KHpa9MzeVkSAgk3zeBfDn+P Wg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrgn7yxu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 18:17:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36DI2jED033199;
        Thu, 13 Jul 2023 18:17:00 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx898k98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 18:17:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7EZ7jAjKA9qSXz/igqxXa/D3xRdhOQiBKoeJyEqItT/Vxall2+TJShK6qhl+3YU8n+CCfsDVImImc7e3RAyxypn98DQvz4/rAgdfGhsProAYeIo/i0CagacWoE8z3J2HIFL9gPZg94ZkgY5nTIGyoQu74nbIIegkkBkrmnNsEf4aLgoSRmQ7tFxhzTFXDOXIfycWaT4pvd1ykphdC16vv8wSz2jWTZNKdnz11BtIZkWwy7ERkLru5VBP5EjX5kQq+L6IsWOhvC37Hqh7lYJxUKQ2kcQBbENnfS3uhgpA5SPFRcXSdh0fqIJ/1Hl+WrWIo66l+OhkTM2jAReNGWgLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=seRIxoKQnNb8qjCOXBTz1wdkU56W4sjWhqbiAdO9q/s=;
 b=Cb6U7Mpc9UQTlwIXxdcWUlpxOFFvKmnLcI1QkHjfEpywiM/ygwWE+9D/cGQFhUkLT4Np3hznVUgrqpERfzjWcAksIg9YhE9LVxmiuP0+RPSukt9RzzYwBFKSUh6P8YaFfY897NR/jJ3+fHkayB+lxynwaRBMFrqIc+j8KZtBE9rZ77V0Ka+NETqkxlkQ7IYKoXC+jnzVrlxHtpROnHFFIM7YSEQaackRdCEjv0kDUWO881+NHZF/QgDwL//yDCYsrmybLPEmJOfzsDfndX8Y1bBOxlmVl22ZDR1bLP2t1Agi65BSVxtvDy/Wxu5BRqMKT0nsr2QWwkNHJnVR0xc0bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=seRIxoKQnNb8qjCOXBTz1wdkU56W4sjWhqbiAdO9q/s=;
 b=nRoltzWRzgbPGKyhII49JNkNs3o+C2GQ2R+mxthAIAdSJiQSB4f4UwhHkwtMzN6RmR6Amvw02do6KdoJCQcGLlIF0gtgUmunxs10WXYt606iv9DrmvrhPCP6xoSrRB/S1LNGcycOSPfctKM3FJS/6zSfB6aE5YFFKloz9EA4se8=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by LV8PR10MB7967.namprd10.prod.outlook.com (2603:10b6:408:206::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Thu, 13 Jul
 2023 18:16:57 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4a17:13b0:2876:97f2]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4a17:13b0:2876:97f2%7]) with mapi id 15.20.6588.017; Thu, 13 Jul 2023
 18:16:57 +0000
Date:   Thu, 13 Jul 2023 11:16:53 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, naoya.horiguchi@linux.dev,
        mhocko@suse.com, linmiaohe@huawei.com, jthoughton@google.com,
        jiaqiyan@google.com, axelrasmussen@google.com
Subject: Re: +
 hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles.patch added
 to mm-hotfixes-unstable branch
Message-ID: <20230713181653.GA4424@monkey>
References: <20230713173444.6B21CC433C8@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713173444.6B21CC433C8@smtp.kernel.org>
X-ClientProxiedBy: MW4PR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:303:16d::20) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|LV8PR10MB7967:EE_
X-MS-Office365-Filtering-Correlation-Id: 62aca476-af9b-4516-a1e0-08db83cd57bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iGqOj6NqpKggq3Nneuf4nWmiCyApNGkFRlT2VCvixBcbqKVGRNT9V5XfngGhk2SuOYYMp3LH7jVsevqyCLP6dtizemyVJm+0yI68XpptUXUy+Bhh+N/ocjf+8EyujJb9ivMvdGAHfuhMWn7VUEshLCjVKVHqu5svTgpwIadtR5K4U9n69pdTj7nB6ay/bS/S1VAOALXhnxxjBdKnUZeCHqJZERtW/JkRGvuq9bHxyNDrNIx0iJXiw2nMU6KBLgVY5zxsyQ5Ky6iQmFC77c8AKQMYWxy18oWiGafCyTrR1BwC6NL/cSzwt2d4+pxbXiCUVVXlWu77PXwtVKLc8nkSAwCkQsRdFnxCXr+n9sWMDXdl9kFKMivhinTJs9ZT5dxoPGZ8jvsL93ehSSp5fJ81UVcpwEEF38eGseNv9pnKyr7TuVy+yjx2od9ay+RqZHMBzQVlho+37RQX6yVfbkT9LWuKA3KEsomERHK9YqpWJpY6Lx/m1l+3TsicOtnt30MfJ3cJDHVSLdke/jwVl5FFG+OBcifvFOQWazQxGz2msH5hG88egVcrYvvNHa8v4Bo8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199021)(6506007)(4326008)(478600001)(6666004)(83380400001)(33656002)(86362001)(15650500001)(4744005)(33716001)(9686003)(6512007)(38100700002)(186003)(8936002)(53546011)(2906002)(1076003)(6486002)(26005)(66946007)(316002)(66556008)(44832011)(41300700001)(8676002)(6916009)(5660300002)(7416002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EyIgmIymMI6Vn+oHUFWkYvbXARzLBwrFxcd+tDMqYa6BIQJn0MOo09xrHj9Q?=
 =?us-ascii?Q?9OPGqOL1hpvv/j03rJTNw4z9saEAdL9/twLs0jMO+hbBLUwGksI1lBeW9qVx?=
 =?us-ascii?Q?fRlOgwCMOd6Q0LPIkjsM18Vq8slyA+5NHWgzxLIahTd8vYpI0QZcGy4ZOMfG?=
 =?us-ascii?Q?WHMiLI1BNjxhGhJeA0WFld3IO/l7fIX0OCpz75qdBCiH5La5O02iCYztJyRh?=
 =?us-ascii?Q?6KBfyUPudeg5GKhPWV4fkN/IS9RSrltrw3pz+4vbHVVqzSnmS92I6o/00+lw?=
 =?us-ascii?Q?brsP9M4mezukQA0jOet4lMDnxY6oUrWh6ELjChQlaHjXACmxTFfP/L5uz7+I?=
 =?us-ascii?Q?bV+mMpcpoRpmCWk73kF8z6RelICtKk036V/jrhiAAAKRXF8jeaxnFFz6Sb2V?=
 =?us-ascii?Q?/cIKI6BB2d//S9X/wFp+wxSxZu0HnRevgXuQs9O6mjGQpj5IUk+rdhLjQuWP?=
 =?us-ascii?Q?3teOphB+ThebcwA+uw6166JMo2mmF/HLqA9joAmSUoI34aWVWx4x/pKYYfO/?=
 =?us-ascii?Q?qMtGJmcB4LavX5aX1tBxtaIY1yCZX9zY7Fhs3GWXxBwl62yvr0mkSgEgqXL1?=
 =?us-ascii?Q?WhaANZCzgwoYbmgHuKwrRNedNE2JYliIWzeHhj9bajZhaIvBax6dijvrB8qH?=
 =?us-ascii?Q?tgrNWXZy34jc3UCOZAYJ2YvoB+J4hyTVp5pclPmdGZcKbIoESoFSRQWAwRem?=
 =?us-ascii?Q?xwKx7jP/vMilfwwfGD3rsb8/Gf5qJP35UeUyWMpehqNJPQ5qPqMegk/4+c1H?=
 =?us-ascii?Q?rCmLDjso5Vxp4L55M+ou8i0qNqDCXT/RTLhLV69p5by4Oe6WXZ3CF6wDNj9o?=
 =?us-ascii?Q?deueyHsxx+k9hlTm0g5bErjxP9COmMPphVuJliQNs7+35jcRYj9yhQyXukTF?=
 =?us-ascii?Q?8RVqVYTqHbDpL4GnWMoW8nA64qvYGSE4qm8c3kMAV2LZ/4aNem6frnlwqWz2?=
 =?us-ascii?Q?MyLAcMfqivC/HdNNMA8irpDsv/hlBt1cmwvWNCb8ifVYcggmxfeWdiB9Zdtl?=
 =?us-ascii?Q?PcjLH13qCMJgyEVNPDvsZY+bqLXE2J/Bt6kGogDZ09C6QRA8OgtkaXPMT8Ik?=
 =?us-ascii?Q?BuHQyirj/SiWDE+MXNiGWV857IBltXpx8BBIL/shVy/WN0TljFee2TSRD+gR?=
 =?us-ascii?Q?vLvq02hWYAOliVFaWnDfw4B7pzAqvXnQXA6D3+xzQ6bbGb732bl9fwmKlwOy?=
 =?us-ascii?Q?jdi4vemgjouCaMIrAaGm8v+Emqm4V/ABA3V5lOLgxxGRkNZ9TbF+fpOFnijQ?=
 =?us-ascii?Q?nYPfSF14jN5KAgxjli4l/L1dhjWKPbGSrkSEiknzL91z5mOHfeQk/o4FBvoI?=
 =?us-ascii?Q?bJXTXkTJukHgyNt6eVUp2fBHX98TKgnIUOUtvo54psGbb3g06LSv5RdwDCrl?=
 =?us-ascii?Q?GJOCK1yzn5o/GdmqZ/fYo0jT3XB9iYjknQvBBs/UgyX0oFSip7Dd8dwkCozR?=
 =?us-ascii?Q?yHBpKDi/eXl8YkBuMh4GYwPAqQXVPKAnvl+P+I+FZNKDrKvw4da/6ScgOwJS?=
 =?us-ascii?Q?4Kn4cabdXDHwZhtKGysCG6g1AiLeDNllHoSTsoNF3sJOpmDzoa5rn00dFVMF?=
 =?us-ascii?Q?DOLmUZNsQ9ivlkTP+kM166EC8Un7+g8R675WUjeT?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?gz3hPyZo9EmptJRmlXkzWaG2fAw9R+n4igqfedvDtuBtgN7zYns37Nnabbz2?=
 =?us-ascii?Q?t2xyjls733yCSCc4h4xd5/WKjYexifNIRYgQETkR+wY0L6RTY1vy1ZZ/ZBci?=
 =?us-ascii?Q?odvWW+t2Qc1/2Vl04IUpZ83kwwjFTAKjd2tZtNCypiwrFECLR2j9k0foPpND?=
 =?us-ascii?Q?KoHfsrSdOJfCmla0YdTXL0/Nx+6y3Ef/TADwlUF5z9sk2/ANEzIRzeBqARNZ?=
 =?us-ascii?Q?c5i2zj7Z2F3Qty9Eg6w+BnFr4ydkd7fU79bFZirRj9MI5K6YUlPQaeMlMgIW?=
 =?us-ascii?Q?lmUGBCueFnz8y4hYWPls9jbaXLKUN1/Epcq5LBGffcTa8sZEhU6wPYlO4IPe?=
 =?us-ascii?Q?HprLCSxa2utvofuATbZmT+eObV2kQrlDy9dSUEePui8xwBwg0dyw2ndYTPjA?=
 =?us-ascii?Q?dhQ8qrz177KYn0kYXogbADLfLBuvxA347YfzuQn6rpGfWlOHSqaVJ9Z492bf?=
 =?us-ascii?Q?OAbUKz8OlRqaE4ZKajSvElMFMSJMGzjzYZZdjanPNJLJY4OKusJG0ppKATAy?=
 =?us-ascii?Q?HwtZdTy85hJR0W2eF1cCqEdDtT3b9i2jtd62BMvGSz7i8wGC+jhENSEulcXl?=
 =?us-ascii?Q?8p3SQcL77PFWHqM8lOiUaBVBelDef0I/lJcQf+4by/5BpEejwgsO2JC1iRI8?=
 =?us-ascii?Q?qrX4GWib/xlinGVbecUeCY2dcG7AKqHV5GJd0Qx++XQhMorckwtmHhh5NzKA?=
 =?us-ascii?Q?91WRaKVQHWwJvlLjQl5vALPWB6Q6wYf/5onDDx21uPOs1ShSYAwsdHRnmJOC?=
 =?us-ascii?Q?fyzVWHmYcjQafqsWLB4qP+puQB5wt7OyBRE5t8cGWMJoaKfBYRpJ1L9lujUB?=
 =?us-ascii?Q?K7EpV4l7fH7xho6iOQ9ZUnPAixCOMCz0IQduGHI6AFc2saQJ0TDIMRjggSAY?=
 =?us-ascii?Q?Lxr0IlN/jq5yliwemkJfcuwZmCkuOEAT2hNac0NY81TS7WdyEmT5mEjfVEfm?=
 =?us-ascii?Q?pTgT1gb9D7TDpQ3GsTekJQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62aca476-af9b-4516-a1e0-08db83cd57bc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 18:16:57.3927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMgBXE0pPHcCOULTczj4KeY5F4CYWOKHVSCyUqAvTVlWSUSnUu8f9XNO4m7cN/SDG0F/BlgGs2/IURNuRQc1Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7967
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_06,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=610
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307130162
X-Proofpoint-ORIG-GUID: Ye4A-vgZzaHPu001vKRPMNiyXlbbCspy
X-Proofpoint-GUID: Ye4A-vgZzaHPu001vKRPMNiyXlbbCspy
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 07/13/23 10:34, Andrew Morton wrote:
> 
> The patch titled
>      Subject: hugetlb: optimize update_and_free_pages_bulk to avoid lock cycles
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles.patch

Muchun pointed out that this patch does not address the issue raised by
Jiaqi Yan.  In fact, I accidentally sent the wrong (previous) version of
the patch.  I mentioned that while getting ready to send the correct version,
I noticed another race window.  I am currently finishing some testing on
that.

Bottom line is that this patch should not move forward.

A new version will be sent and I will attempt to answer your questions about
introducing a performance regression.

Sorry for any confusion,
-- 
Mike Kravetz
